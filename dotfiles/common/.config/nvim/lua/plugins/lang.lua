-- Adjustments to LazyVim's language extras (init.lua lists them).
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- nixd instead of the Nix extra's nil, with this machine's NixOS options.
        nil_ls = { enabled = false },
        nixd = {
          settings = {
            nixd = {
              formatting = { command = { "nixfmt" } },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/etc/nixos").nixosConfigurations.' .. vim.fn.hostname() .. ".options",
                },
              },
            },
          },
        },
        -- HTML and CSS have no extra; both come from vscode-langservers-extracted.
        html = {},
        cssls = {},
      },
      setup = {
        -- The Go extra patches in semantic tokens for old gopls and fails ("attempt to index field
        -- 'textDocument'"); gopls has them itself now (semanticTokens = true).
        gopls = function() end,
      },
    },
  },
}
