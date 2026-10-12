{ pkgs, ... }:

{
  # Enable the Niri Wayland compositor
  programs.niri.enable = true;
  # The niri-flake default is still 25.08; use the stable release in locked nixpkgs.
  programs.niri.package = pkgs.niri;

  # Electron / Chromium apps should use Wayland natively
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GTK_USE_PORTAL = "1";
  };

  # XDG Desktop Portal for file dialogs, screen sharing, etc.
  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "gtk" ];
      # Screencasting on niri only works via the gnome portal (niri implements mutter's ScreenCast API)
      niri.default = [ "gnome" "gtk" ];
      niri."org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Packages needed for a complete Niri desktop experience
  environment.systemPackages = with pkgs; [
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

    # Wayland wallpaper
    awww

    # Lock screen
    swaylock-effects

    # Dmenu replacement for wayland (clipboard manager UI)
    fuzzel


  ];
}
