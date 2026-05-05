{
  description = "Basic setup flake";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
        url = "github:nix-community/home-manager/release-24.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = { self, nixpkgs,nixpkgs-unstable, home-manager, ... }: {
    nixosConfigurations.nietzsche = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";


      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.friedrich = import ./modules/home.nix;
        }
      ];
    };
  };
}
