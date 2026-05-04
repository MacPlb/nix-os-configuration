{ config, pkgs, ... }:

{
  home.username = "friedrich";
  home.homeDirectory = "/home/friedrich";
  home.stateVersion = "24.11";

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      monitor = [
        "DP-1, 1920x1080@144, 0x0, 1, transform, 1"
      ];
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, kitty"
        "$mod, R, exec, wofi --show drun"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
      ];
      exec-once = [
        "waybar"
        "swww init"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
    };
  };

  programs.waybar.enable = true;
  programs.wofi.enable = true;
  programs.kitty.enable = true;

  home.packages = with pkgs; [
    grim
    slurp
    swappy
    cliphist
    wl-clipboard
    swww
    nerdfonts
  ];

  programs.home-manager.enable = true;
}
