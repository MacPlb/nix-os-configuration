{ pkgs, ... }:

{
  # Nemo's Python extensions (emblems, folder colours) more than double its startup
  # (~490 ms -> ~210 ms without them); keep only the archive (file-roller) menu.
  nixpkgs.overlays = [
    (final: prev: {
      nemo-with-extensions = prev.nemo-with-extensions.override {
        useDefaultExtensions = false;
        extensions = [ final.nemo-fileroller ];
      };
    })
  ];

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 3";
    };
  };

  environment.systemPackages = with pkgs; [
    nemo-with-extensions

    # Extra GNU tools; coreutils, grep, sed, tar, less etc. are in the base system.
    parallel
    wget
    gnupg
    gnumake
    binutils
    texinfo
  ];

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };

  environment.shellAliases = {
    nixswitch = "nh os switch /etc/nixos";
    nixtest = "nh os test /etc/nixos";
    nixboot = "nh os boot /etc/nixos";
    nixconf = "sudoedit /etc/nixos/configuration.nix";

    nixgc = "nh clean all";
    nixclean = "nh clean all --keep-since 7d --keep 3";
    nixopt = "nix-store --optimise";

    nshell = "nix-shell -p";
    nsearch = "nix search nixpkgs";
    nrun = "nix run";
    cls = "clear";

    noctalia-restart = "systemctl --user restart noctalia.service";
  };

  # programs.nh.flake already exports NH_FLAKE.
  environment.variables.TERMINAL = "kitty";
}
