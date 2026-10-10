{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  programs.doom-emacs = {
    enable = true;
    emacs = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      epkgs.treesit-grammars.with-all-grammars
    ];
  };

  services.emacs = {
    enable = true;
    client = {
      enable = true;
      arguments = [ "-c" ];
    };
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    nixfmt-rfc-style

    # Doom/LSP support
    gopls
    gotools
    rust-analyzer
    rustfmt
    clippy
    pyright
    ruff
    black
    isort
    lua-language-server
    omnisharp-roslyn
    netcoredbg
    dotnet-sdk
  ];

  home.sessionVariables = {
    VISUAL = "emacsclient -c -a emacs";
  };
}
