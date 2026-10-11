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

      # Declarative Doom Emacs packaged through Home Manager
      nix-doom-emacs-unstraightened = {
        url = "github:marienz/nix-doom-emacs-unstraightened";
        inputs = {
          doomdir.url = "path:./modules/home/doom.d";
          nixpkgs.follows = "nixpkgs";
        };
      };
    };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, niri, noctalia-shell, nix-doom-emacs-unstraightened, ... }@inputs: {
    nixosConfigurations.nietzsche = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };

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
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        }
      ];
    };
  };
}
