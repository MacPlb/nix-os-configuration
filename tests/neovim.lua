-- Run with the generated init.lua, Nix plugins and isolated /tmp XDG data.
assert(vim.fn.stdpath("data"):sub(1, 5) == "/tmp/", "Use isolated test data")
assert(vim.v.errmsg == "", vim.v.errmsg)
assert(vim.g.syntax_on == 1, "Syntax highlighting is disabled")
assert(vim.api.nvim_get_hl(0, { name = "Normal" }).bg == tonumber("1a1a2e", 16))
for _, server in ipairs({ "omnisharp", "rust_analyzer", "gopls", "pyright", "clangd" }) do
  assert(vim.lsp.is_enabled(server), server .. " is disabled")
  local config = vim.lsp.config[server]
  assert(config and config.filetypes and #config.filetypes > 0)
  assert(vim.fn.executable(config.cmd[1]) == 1, server .. " executable is missing")
end
assert(vim.fn.executable("dotnet") == 1, "C# SDK is missing")
assert(vim.fn.maparg("gd", "n", false, true).callback == vim.lsp.buf.definition)

vim.cmd.edit("flake.nix")
assert(vim.bo.filetype == "nix")
assert(vim.wait(5000, function()
  return vim.b.minigit_summary and vim.b.minigit_summary.head_name ~= nil
end), "Git branch did not load")
local branch = vim.trim(vim.fn.system({ "git", "branch", "--show-current" }))
assert(vim.b.minigit_summary.head_name == branch, "Wrong Git branch")
assert(MiniStatusline.section_git({ trunc_width = 0 }):find(branch, 1, true))

local harpoon = require("harpoon")
harpoon:list():clear()
local files = { "flake.nix", "README.md", "configuration.nix", "modules/home/default.nix" }
for _, file in ipairs(files) do
  vim.cmd.edit(file)
  vim.fn.maparg(" a", "n", false, true).callback()
end
assert(harpoon:list():length() == 4)
for i, file in ipairs(files) do
  vim.fn.maparg(" " .. i, "n", false, true).callback()
  assert(vim.fn.expand("%:p") == vim.fn.fnamemodify(file, ":p"), "Wrong Harpoon target")
end
vim.fn.maparg(" h", "n", false, true).callback()
assert(vim.bo.filetype == "harpoon", "Harpoon menu did not open")
local workspace = vim.fn.tempname()
vim.fn.mkdir(workspace, "p")
vim.fn.writefile({}, workspace .. "/pyproject.toml")
vim.fn.writefile({}, workspace .. "/.clangd")
for _, fixture in ipairs({
  { server = "pyright", file = "main.py", text = "value: int = 1" },
  { server = "clangd", file = "main.c", text = "int main(void) { return 0; }" },
}) do
  vim.fn.writefile({ fixture.text }, workspace .. "/" .. fixture.file)
  vim.cmd.edit(workspace .. "/" .. fixture.file)
  assert(vim.wait(15000, function()
    local client = vim.lsp.get_clients({ bufnr = 0, name = fixture.server })[1]
    return client and client.initialized
  end), fixture.server .. " failed to attach")
end
print("Neovim: palette, syntax, Git branch, Harpoon and LSP checks passed")
vim.cmd.qa({ bang = true })
