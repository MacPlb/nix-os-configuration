{ pkgs, inputs, ... }:

{
  # Enable the Niri Wayland compositor
  programs.niri.enable = true;

  # Electron / Chromium apps should use Wayland natively
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # XDG Desktop Portal for file dialogs, screen sharing, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Packages needed for a complete Niri desktop experience
  environment.systemPackages = with pkgs; [
    # Noctalia desktop shell (bar, notifications, widgets)
    inputs.noctalia-shell.packages.${pkgs.system}.default

    # Terminal
    kitty

    # Application launcher
    wofi

    # Clipboard utilities
    wl-clipboard
    cliphist

    # Screenshot pipeline
    grim
    slurp
    swappy

    # Audio control
    pavucontrol
    playerctl

    # Network tray applet
    networkmanagerapplet

    # Wallpaper daemon
    swww
  ];
}
