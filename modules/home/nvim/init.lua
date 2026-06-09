-- Bootstrap and load all configuration
-- Enable native Lua module caching (Neovim 0.9+)
vim.loader.enable()

-- Leader key must be set before lazy.nvim loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core vim options
require("config.set")

-- Keymaps
require("config.remap")

-- Plugin manager (lazy.nvim)
require("config.lazy")
