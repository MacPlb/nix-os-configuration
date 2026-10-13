{ pkgs, ... }:

{
  # Enable the Niri Wayland compositor
  programs.niri.enable = true;
  # The niri-flake default is still 25.08; use the stable release in locked nixpkgs.
  programs.niri.package = pkgs.niri;

  # Electron / Chromium apps should use Wayland natively
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # XDG Desktop Portal for file dialogs, screen sharing, etc.
  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "gtk" ];
      # Screencasting on niri only works via the gnome portal (niri implements mutter's ScreenCast API)
      niri.default = [
        "gnome"
        "gtk"
      ];
      niri."org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Noctalia is the polkit agent; drop niri-flake's polkit-kde agent.
  systemd.user.services.niri-flake-polkit.enable = false;

  # Backend for the noctalia/screen_recorder plugin.
  programs.gpu-screen-recorder.enable = true;

  # Packages needed for a complete Niri desktop experience
  environment.systemPackages = with pkgs; [
    # Terminal
    kitty

    # Clipboard CLI (nemo screenshot paste, neovim); history lives in Noctalia
    wl-clipboard
  ];
}
