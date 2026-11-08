{
  description = "NixOS for nietzsche (desktop) and dostoyevsky (laptop): Niri, Noctalia and plain dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Module system for the flake itself.
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Rust toolchains with rust-src for RustRover.
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Noctalia desktop shell (status bar, notifications, widgets for Wayland)
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia login greeter for greetd (replaces GDM)
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Every .nix file under modules/ is imported as a flake-parts module. Files starting
  # with "_" are skipped (the hardware configs).
  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;

      isModule = file: file.hasExt "nix" && !lib.hasPrefix "_" file.name;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = lib.fileset.toList (lib.fileset.fileFilter isModule ./modules);
    };
}
