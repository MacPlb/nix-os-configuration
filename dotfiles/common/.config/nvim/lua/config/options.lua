-- Loaded before the plugins; LazyVim's own defaults: lua/lazyvim/config/options.lua in LazyVim.
local opt = vim.opt
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.shiftwidth = 4
opt.tabstop = 4
opt.updatetime = 250
opt.timeoutlen = 400
opt.winborder = "rounded"
opt.synmaxcol = 300 -- long lines (minified JSON) don't stall regex highlighting
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- No remote plugins; keeps :checkhealth clean.
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Project root (pickers, explorer, grep): the language server's, else the nearest of these.
vim.g.root_spec = {
  "lsp",
  { ".git", "*.sln", "*.slnx", "flake.nix", "go.mod", "package.json", "pyproject.toml", "Cargo.toml", "lua" },
  "cwd",
}

-- Let kitty's background opacity show through the editor (<Space>uB toggles it).
vim.g.transparent = true
