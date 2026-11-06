-- Loaded on VeryLazy; LazyVim's own keys: lua/lazyvim/config/keymaps.lua in LazyVim, or
-- <Space>sk. Ours are listed in cheatsheet.md (<F1>).
local map = vim.keymap.set

local function open_cheatsheet()
  local path = vim.fn.stdpath("config") .. "/cheatsheet.md"
  if vim.fn.filereadable(path) == 0 then
    return vim.notify("No cheatsheet at " .. path, vim.log.levels.WARN)
  end
  Snacks.win({
    file = path,
    width = 0.8,
    height = 0.85,
    title = " Neovim cheatsheet (q to close, / to search) ",
    title_pos = "center",
    wo = { wrap = true, conceallevel = 2, spell = false },
    bo = { modifiable = false },
  })
end
vim.api.nvim_create_user_command("Cheatsheet", open_cheatsheet, { desc = "Open the keymap cheatsheet" })
map("n", "<F1>", open_cheatsheet, { desc = "Cheatsheet" })

Snacks.toggle({
  name = "Transparent Background",
  get = function() return vim.g.transparent ~= false end,
  set = function(on)
    vim.g.transparent = on
    require("config.colors").apply_transparency()
  end,
}):map("<leader>uB")

-- Visual Studio / Rider keys
local dap = function(fn) return function() require("dap")[fn]() end end
map("n", "<F5>", dap("continue"), { desc = "Debug: start / continue" })
map("n", "<S-F5>", dap("terminate"), { desc = "Debug: stop" })
map("n", "<F9>", dap("toggle_breakpoint"), { desc = "Debug: toggle breakpoint" })
map("n", "<F10>", dap("step_over"), { desc = "Debug: step over" })
map("n", "<F11>", dap("step_into"), { desc = "Debug: step into" })
map("n", "<S-F11>", dap("step_out"), { desc = "Debug: step out" })
map("n", "<F12>", function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition" })
map("n", "<S-F12>", function() Snacks.picker.lsp_references() end, { desc = "Find usages" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "x" }, "<M-CR>", vim.lsp.buf.code_action, { desc = "Code action / quick fix" })

-- jq copes with JSON of any size, also big files where LSP and prettier are off.
map("n", "<leader>cj", "<cmd>%!jq .<cr>", { desc = "Format JSON with jq" })
map("n", "<leader>cJ", "<cmd>%!jq -c .<cr>", { desc = "Minify JSON with jq" })
