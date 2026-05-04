{
  description = "Basic setup flake";

  # Using std version
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; 
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix 
        ];
      };
    };
  };
}