# Tools for working on this repo: run `nix-shell`, then `make help`
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [ gnumake git rsync ];

  shellHook = ''
    make --no-print-directory help
  '';
}
