-- LazyVim on lazy.nvim. Nix supplies the plugins, language servers, formatters and debuggers
-- (modules/features/neovim.nix); lazy.nvim loads them from the store, and Mason is off.
-- Settings: lua/config/ and lua/plugins/. Keys: cheatsheet.md (<F1>), <Space>sk searches them.
local plugins = vim.env.NVIM_LAZY_PLUGINS -- set by the Nix wrapper
if not plugins then
  vim.api.nvim_echo({ { "NVIM_LAZY_PLUGINS is unset; start the nvim that Nix installs", "ErrorMsg" } }, true, {})
  return
end
vim.opt.rtp:prepend(plugins .. "/lazy.nvim")

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Extras (`:LazyExtras` describes them). These four have to come first, in this order.
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- Languages (C# is lua/plugins/dotnet.lua: Roslyn instead of the OmniSharp extra)
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.nix" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.sql" },
    { import = "lazyvim.plugins.extras.lang.git" },
    { import = "lazyvim.plugins.extras.util.dot" },
    -- Editing and UI
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.yanky" },
    { import = "lazyvim.plugins.extras.editor.harpoon2" },
    { import = "lazyvim.plugins.extras.editor.inc-rename" },
    { import = "lazyvim.plugins.extras.editor.dial" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },

    { import = "plugins" },
  },
  defaults = { lazy = false, version = false },
  -- Every plugin comes from the Nix folder, by repo name ("folke/snacks.nvim" -> snacks.nvim).
  dev = { path = plugins, patterns = { "" }, fallback = false },
  install = { missing = false },
  checker = { enabled = false },
  change_detection = { enabled = false },
  rocks = { enabled = false },
  lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json", -- versions are pinned by flake.lock
  performance = {
    rtp = { disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
})
