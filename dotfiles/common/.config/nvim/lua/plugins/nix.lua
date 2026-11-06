-- Nix provides the tools and grammars LazyVim would otherwise download.
return {
  -- Language servers, formatters, linters and debuggers are on nvim's PATH; LazyVim enables the
  -- servers itself when Mason is absent.
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },

  -- Grammars come compiled from Nix (NVIM_TS_PARSERS: parser/ and queries/); nothing is installed.
  {
    "nvim-treesitter/nvim-treesitter",
    build = false,
    opts = function(_, opts)
      opts.install_dir = vim.env.NVIM_TS_PARSERS
      opts.ensure_installed = {}
    end,
  },

  -- debugpy from Nix; the project's own venv still runs the code.
  {
    "mfussenegger/nvim-dap-python",
    config = function() require("dap-python").setup(vim.env.NVIM_DEBUGPY_PYTHON or "python3") end,
  },
}
