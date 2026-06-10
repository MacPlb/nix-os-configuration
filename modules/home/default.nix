{ ... }:

{
  home.username = "friedrich";
  home.homeDirectory = "/home/friedrich";
  home.stateVersion = "24.11";

  imports = [
    ./niri-keybinds.nix
    ./niri-appearance.nix
    ./niri-outputs.nix
    ./niri-startup.nix
    ./noctalia.nix
    ./kitty.nix
    ./fuzzel.nix
    ./gtk-qt-theme.nix
    ./starship.nix
    ./neovim.nix
  ];

  # Auto-mount USB drives
  services.udiskie = {
    enable = true;
    automount = true;
    tray = "never";
  };

  # Default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "x-scheme-handler/file" = [ "org.gnome.Nautilus.desktop" ];
    };
  };

  # Enable HomeManager
  programs.home-manager.enable = true;
}
