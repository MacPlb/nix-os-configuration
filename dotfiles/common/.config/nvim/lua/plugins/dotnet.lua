-- C#/.NET: Roslyn (the same server as VS Code) through roslyn.nvim instead of LazyVim's OmniSharp
-- extra, csharpier, netcoredbg, neotest-dotnet, and dotnet build/run/watch under <Space>N.

-- The nearest file matching `pattern` above the current file.
local function nearest(pattern)
  local name = vim.api.nvim_buf_get_name(0)
  local start = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
  return vim.fs.find(function(file) return file:match(pattern) ~= nil end, { path = start, upward = true, limit = 1 })[1]
end

local function pick_csproj(callback)
  local here = nearest("%.csproj$")
  if here then return callback(here) end
  local all = vim.fs.find(function(f) return f:match("%.csproj$") ~= nil end, { path = LazyVim.root(), limit = 200 })
  if #all == 0 then return vim.notify("No .csproj found", vim.log.levels.WARN) end
  if #all == 1 then return callback(all[1]) end
  vim.ui.select(all, { prompt = "Project" }, function(choice) if choice then callback(choice) end end)
end

local function solution_or_project() return nearest("%.slnx?$") or nearest("%.csproj$") end

local msbuild_efm = "%f(%l\\,%c): %trror %m,%f(%l\\,%c): %tarning %m"

-- Runs `dotnet <args>` in the background; errors and warnings land in the quickfix list.
local function dotnet(args, target, on_done)
  local title = "dotnet " .. table.concat(args, " ")
  vim.notify(title .. " …")
  local cmd = vim.list_extend({ "dotnet" }, args)
  if target then table.insert(cmd, target) end
  vim.system(cmd, { text = true, cwd = target and vim.fs.dirname(target) or LazyVim.root() }, function(res)
    vim.schedule(function()
      local lines = vim.split((res.stdout or "") .. "\n" .. (res.stderr or ""), "\n")
      local seen, items = {}, {}
      for _, item in ipairs(vim.fn.getqflist({ lines = lines, efm = msbuild_efm }).items) do
        local key = item.bufnr .. ":" .. item.lnum .. ":" .. item.col .. ":" .. item.text
        if item.valid == 1 and not seen[key] then
          seen[key] = true
          table.insert(items, item)
        end
      end
      vim.fn.setqflist({}, " ", { title = title, items = items })
      if res.code == 0 then
        vim.notify(title .. " succeeded" .. (#items > 0 and (" (" .. #items .. " warnings)") or ""))
      else
        vim.notify(title .. " failed", vim.log.levels.ERROR)
        if #items > 0 then vim.cmd("Trouble qflist open") end
      end
      if on_done then on_done(res.code == 0) end
    end)
  end)
end

local function in_terminal(args)
  pick_csproj(function(csproj)
    Snacks.terminal(vim.list_extend({ "dotnet" }, vim.list_extend(args, { "--project", csproj })), {
      cwd = vim.fs.dirname(csproj),
      auto_close = false,
      win = { position = "bottom", height = 0.3 },
    })
  end)
end

return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    -- Roslyn watches the solution's files itself, much faster than nvim's watcher on big trees;
    -- lock_target stops it reloading when a file from another solution is opened (<Space>Ns switches).
    opts = { filewatching = "roslyn", lock_target = true },
    config = function(_, opts)
      vim.lsp.config("roslyn", {
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_parameters = true,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          -- Analyzing the whole solution in the background keeps Roslyn busy (and slow to answer)
          -- on big solutions; <Space>Nb puts every build error in the quickfix list instead.
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|symbol_search"] = { dotnet_search_reference_assemblies = true },
        },
        handlers = {
          -- roslyn.nvim's own handler asks every server (JSON, Python…) for the current buffer's
          -- diagnostics, which fails with "Failed to get language". Refresh only Roslyn's buffers.
          ["workspace/projectInitializationComplete"] = function(_, _, ctx)
            vim.notify("Roslyn project initialization complete", vim.log.levels.INFO, { title = "roslyn.nvim" })
            vim.api.nvim_exec_autocmds("User", {
              pattern = "RoslynInitialized",
              modeline = false,
              data = { client_id = ctx.client_id },
            })
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            for buf in pairs(client and client.attached_buffers or {}) do
              if vim.api.nvim_buf_is_loaded(buf) then vim.lsp.diagnostic._refresh(buf, ctx.client_id) end
            end
          end,
        },
      })
      require("roslyn").setup(opts)
    end,
  },

  { "stevearc/conform.nvim", opts = { formatters_by_ft = { cs = { "csharpier" } } } },

  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local netcoredbg = { type = "executable", command = "netcoredbg", args = { "--interpreter=vscode" } }
      dap.adapters.coreclr = netcoredbg
      dap.adapters.netcoredbg = netcoredbg
      -- Launch: build the project, then debug bin/Debug/<tfm>/<Project>.dll.
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch project (builds first)",
          request = "launch",
          program = function()
            return coroutine.create(function(co)
              pick_csproj(function(csproj)
                dotnet({ "build", "-c", "Debug" }, csproj, function(ok)
                  if not ok then return coroutine.resume(co, dap.ABORT) end
                  local dir = vim.fs.dirname(csproj)
                  local dll = vim.fn.fnamemodify(csproj, ":t:r") .. ".dll"
                  local hits = vim.fn.glob(dir .. "/bin/Debug/*/" .. dll, false, true)
                  table.sort(hits, function(a, b) return vim.uv.fs_stat(a).mtime.sec > vim.uv.fs_stat(b).mtime.sec end)
                  if hits[1] then return coroutine.resume(co, hits[1]) end
                  vim.ui.input({ prompt = "Path to dll: ", default = dir .. "/bin/Debug/", completion = "file" }, function(path)
                    coroutine.resume(co, path or dap.ABORT)
                  end)
                end)
              end)
            end)
          end,
          cwd = function()
            local csproj = nearest("%.csproj$")
            return csproj and vim.fs.dirname(csproj) or LazyVim.root()
          end,
          env = { ASPNETCORE_ENVIRONMENT = "Development", DOTNET_ENVIRONMENT = "Development" },
        },
        {
          type = "coreclr",
          name = "Attach to process",
          request = "attach",
          processId = function() return require("dap.utils").pick_process() end,
        },
      }
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = { "Issafalcon/neotest-dotnet" },
    opts = {
      adapters = {
        ["neotest-dotnet"] = { dap = { adapter_name = "netcoredbg" }, discovery_root = "solution" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>N", group = ".NET", icon = { icon = "󰪮", color = "purple" } } } },
  },

  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>Nb", function() dotnet({ "build" }, solution_or_project()) end, desc = "Build" },
      { "<leader>NB", function() dotnet({ "build", "--no-incremental" }, solution_or_project()) end, desc = "Rebuild" },
      { "<leader>Nc", function() dotnet({ "clean" }, solution_or_project()) end, desc = "Clean" },
      { "<leader>NR", function() dotnet({ "restore" }, solution_or_project()) end, desc = "Restore NuGet packages" },
      { "<leader>Nr", function() in_terminal({ "run" }) end, desc = "Run project (terminal)" },
      { "<leader>Nw", function() in_terminal({ "watch" }) end, desc = "Run with hot reload (dotnet watch)" },
      { "<leader>Ns", "<cmd>Roslyn target<cr>", desc = "Choose solution for C# server" },
    },
  },
}
