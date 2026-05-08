{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    keepassxc
    firefox
    vesktop
    signal-desktop
    htop
    rhythmbox
  ];
}
