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

  # Enable HomeManager
  programs.home-manager.enable = true;
}
