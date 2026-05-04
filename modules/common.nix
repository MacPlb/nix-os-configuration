{ config, pkgs, ... }:

{ 
    # Garbage collection
    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
    };
    
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
        nixswitch = "nh os switch";
        nixtest   = "nh os test";
        nixboot   = "nh os boot";
        nixconf   = "sudo nano /etc/nixos/configuration.nix";
        
        nixgc     = "nh clean all";
        nixclean  = "nh clean all --keep-since 7d --keep 3";
        nixopt    = "nix-store --optimise";
        
        nshell    = "nix-shell -p";
        nsearch   = "nix search nixpkgs";
        nrun      = "nix run";
        cls       = "clear";
    };

}