{ pkgs, ... }:

{
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 3";
    };
  };

  environment.systemPackages = with pkgs; [
    nemo
  ];

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };

  environment.shellAliases = {
    nixswitch = "nh os switch /etc/nixos";
    nixtest = "nh os test /etc/nixos";
    nixboot = "nh os boot /etc/nixos";
    nixconf = "sudo emacs /etc/nixos/configuration.nix";

    nixgc = "nh clean all";
    nixclean = "nh clean all --keep-since 7d --keep 3";
    nixopt = "nix-store --optimise";

    nshell = "nix-shell -p";
    nsearch = "nix search nixpkgs";
    nrun = "nix run";
    cls = "clear";

    noctalia-restart = "systemctl --user restart noctalia.service";
  };

  environment.variables = {
    FLAKE = "/etc/nixos";
    TERMINAL = "kitty";
  };
}
