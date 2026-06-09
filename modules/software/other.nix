{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    keepassxc
    firefox
    vesktop
    signal-desktop
    htop
    rhythmbox
    fastfetch
    xwayland-satellite
    pkgs-unstable.spotube
    pkgs-unstable.yt-dlp
  ];
}