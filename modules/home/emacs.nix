{ inputs, pkgs, lib, ... }:

{
  imports = [
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  programs.doom-emacs = {
    enable = true;
    emacs = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      (epkgs.treesit-grammars.with-grammars (grammars: with grammars; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-cpp
        tree-sitter-c-sharp
        tree-sitter-go
        tree-sitter-gomod
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-markdown
        tree-sitter-markdown-inline
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-rust
        tree-sitter-yaml
      ]))
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
    nixfmt

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
    VISUAL = lib.mkForce "emacsclient -c -a emacs";
  };
}
