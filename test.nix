{ pkgs ? import <nixpkgs> {} }:
let
  hm = import (fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz") {};
in
  hm.lib.hm.options
