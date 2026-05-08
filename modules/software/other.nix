{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    keepassxc
    firefox
    vesktop
    signal-desktop
    nuclear
    htop
  ];
}
