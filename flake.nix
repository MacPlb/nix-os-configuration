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

    # Noctalia login greeter for greetd (replaces GDM)
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      niri,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nietzsche = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs pkgs-unstable; };

        modules = [
          ./hosts/nietzsche

          # Niri compositor NixOS module
          niri.nixosModules.niri

          inputs.noctalia-greeter.nixosModules.default

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

      # `nix fmt` formats every .nix file in the repo.
      formatter.${system} = pkgs.nixfmt-tree;

      # `nix develop`: tools for working on this repo, then `make help`.
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          gnumake
          git
          rsync
          nixfmt-tree
        ];
        shellHook = "make --no-print-directory help";
      };

      # `nix flake check` also builds the system, so evaluation errors fail it.
      checks.${system} = {
        nietzsche = self.nixosConfigurations.nietzsche.config.system.build.toplevel;
        nemo-paste-screenshot = pkgs.runCommand "nemo-paste-screenshot-tests" {
          nativeBuildInputs = [ pkgs.python3 ];
          PYTHONDONTWRITEBYTECODE = 1;
        } "cd ${./.} && python3 -m unittest discover -s tests && touch $out";
      };
    };
}
