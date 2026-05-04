{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    kitty
    waybar
    mako
    swww
    rofi-wayland
    networkmanagerapplet
    pavucontrol
    wl-clipboard

    # Screenshot tools
    grim
    slurp
    swappy

    # Clipboard manager
    cliphist
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}