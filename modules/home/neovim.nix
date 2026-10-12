{ config, lib, pkgs, ... }:

let
  kitty = config.programs.kitty.settings;
  palette = {
    base00 = kitty.background;
    base01 = kitty.inactive_tab_background;
    base02 = kitty.selection_background;
    base03 = kitty.color8;
    base04 = kitty.inactive_tab_foreground;
    base05 = kitty.foreground;
    base06 = kitty.color7;
    base07 = kitty.color15;
    base08 = kitty.color1;
    base09 = kitty.color9;
    base0A = kitty.color3;
    base0B = kitty.color2;
    base0C = kitty.color6;
    base0D = kitty.color4;
    base0E = kitty.color5;
    base0F = kitty.color13;
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
    extraPackages = with pkgs; [
      wl-clipboard
      omnisharp-roslyn
      dotnet-sdk
      rust-analyzer
      gopls
      pyright
      clang-tools
    ];
    plugins = with pkgs.vimPlugins; [
      mini-base16
      mini-git
      mini-statusline
      harpoon2
      nvim-lspconfig
    ];
    initLua = ''
      vim.g.mapleader = " "
      vim.opt.number = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.termguicolors = true
      vim.cmd("filetype plugin indent on")
      vim.cmd("syntax enable")

      require("mini.base16").setup({
        palette = vim.json.decode(${builtins.toJSON (builtins.toJSON palette)}),
      })
      vim.api.nvim_set_hl(0, "Cursor", { fg = "${kitty.cursor_text_color}", bg = "${kitty.cursor}" })
      vim.api.nvim_set_hl(0, "Visual", { fg = "${kitty.selection_foreground}", bg = "${kitty.selection_background}" })
      require("mini.git").setup()
      require("mini.statusline").setup({ use_icons = false })

      vim.lsp.enable({ "omnisharp", "rust_analyzer", "gopls", "pyright", "clangd" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
      vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: menu" })
      for i = 1, 4 do
        vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon: file " .. i })
      end
    '';
  };

  home.sessionVariables.VISUAL = lib.mkForce "nvim";
}
