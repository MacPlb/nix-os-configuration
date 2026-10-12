{ pkgs, ... }:

{
  # Enable the Niri Wayland compositor
  programs.niri.enable = true;
  # The niri-flake default is still 25.08; use the stable release in locked nixpkgs.
  programs.niri.package = pkgs.niri;

  # Keep shortcut handling responsive when applications saturate the CPU.
  systemd.user.slices.session.sliceConfig.CPUWeight = 1000;
  systemd.user.services.niri = {
    overrideStrategy = "asDropin";
    serviceConfig.CPUWeight = 1000;
  };

  # Give desktop reads deadlines while builds flood NVMe with writes.
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="nvme[0-9]*n[0-9]*", ENV{DEVTYPE}=="disk", ATTR{queue/scheduler}="mq-deadline"
  '';

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
