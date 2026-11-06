# Package sets: stable nixpkgs as `pkgs`, nixos-unstable (with the Rust overlay) as `pkgs.unstable`.
{ inputs, ... }:

{
  flake.nixosModules.base = {
    nixpkgs.config.allowUnfree = true;

    nixpkgs.overlays = [
      (final: _: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfree = true;
          overlays = [ inputs.rust-overlay.overlays.default ];
        };
      })
    ];
  };
}
