{ pkgs, pkgs-unstable, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = pkgs-unstable.neovim-unwrapped;

    # LSP servers and tools available on $PATH for Neovim
    extraPackages = with pkgs; [
      # LSP servers
      gopls                    # Go
      pyright                  # Python
      omnisharp-roslyn         # C# / .NET
      lua-language-server      # Lua (for editing config)

      # Telescope dependencies
      fd

      # Treesitter needs a C compiler for parser compilation
      gcc
    ];
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}