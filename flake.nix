{
  description = "Basic setup flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05"; 
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; 
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }: {
    nixosConfigurations = {
      nietzsche = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true; 
          };
        };

        modules = [
          ./configuration.nix 
        ];
      };
    };
  };
}