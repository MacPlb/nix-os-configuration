{ config, pkgs, ... }:

{ 
    # Garbage collection
    nix.gc.automatic = false;
    
    # Store optimazation
    nix.settings.auto-optimise-store = true;


    # System managment

    programs.nh = {
        enable = true;
        flake = "/etc/nixos"; 
            clean = {
            enable = true;
            extraArgs = "--keep-since 7d --keep 3";
        };
    };

    # Aliases to commands
    environment.shellAliases = {
        nixswitch = "nh os switch /etc/nixos";
        nixtest   = "nh os test /etc/nixos";
        nixboot   = "nh os boot /etc/nixos";
        nixconf   = "sudo neovim /etc/nixos/configuration.nix";

        nixgc     = "nh clean all";
        nixclean  = "nh clean all --keep-since 7d --keep 3";
        nixopt    = "nix-store --optimise";
        
        nshell    = "nix-shell -p";
        nsearch   = "nix search nixpkgs";
        nrun      = "nix run";
        cls       = "clear";
    };

    #Env variables
    environment.variables.FLAKE = "/etc/nixos";

}