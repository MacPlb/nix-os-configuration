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
    inputs.noctalia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Terminal
    kitty

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

    # Video wallpaper (mpv-based)
    mpvpaper

    # Lock screen
    swaylock-effects

    # Dmenu replacement for wayland (clipboard manager UI)
    fuzzel

    # File manager
    xfce.thunar
    xfce.tumbler
  ];
}
