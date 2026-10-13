{
  description = "Basic setup flake";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Niri Wayland compositor (provides programs.niri with Home Manager support)
      niri = {
        url = "github:sodiboo/niri-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Noctalia desktop shell (status bar, notifications, widgets for Wayland)
      noctalia-shell = {
        url = "github:noctalia-dev/noctalia-shell";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, niri, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nietzsche = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs pkgs-unstable; };

      modules = [
        ./configuration.nix

        # Niri compositor NixOS module
        niri.nixosModules.niri

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.friedrich = import ./modules/home;
          home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
        }
      ];
    };
  };
}
