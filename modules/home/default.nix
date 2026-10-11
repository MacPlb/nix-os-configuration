{ pkgs, lib, ... }:

let
  hiddenDesktopEntry = name: exec: ''
    [Desktop Entry]
    Type=Application
    Name=${name}
    Exec=${exec}
    NoDisplay=true
  '';
in
{
  home.username = "friedrich";
  home.homeDirectory = "/home/friedrich";
  home.stateVersion = "24.11";

  imports = [
    ./niri-keybinds.nix
    ./niri-appearance.nix
    ./niri-outputs.nix
    ./niri-startup.nix
    ./clipboard.nix
    ./noctalia.nix
    ./kitty.nix
    ./fuzzel.nix
    ./gtk-qt-theme.nix
    ./starship.nix
    ./emacs.nix
  ];

  services.udiskie = {
    enable = true;
    automount = true;
    tray = "never";
  };

  xdg.desktopEntries.nemo = {
    name = "Files";
    genericName = "File Manager";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo %U";
    icon = "system-file-manager";
    terminal = false;
    categories = [
      "GNOME"
      "GTK"
      "Utility"
      "Core"
      "System"
      "FileManager"
    ];
    mimeType = [
      "inode/directory"
      "inode/mount-point"
      "application/x-directory"
      "application/x-gnome-saved-search"
      "x-directory/normal"
      "x-scheme-handler/file"
    ];
  };

  programs.fuzzel.settings = {
    main = {
      icons-enabled = true;
      icon-theme = "Papirus-Dark";
      image-size-ratio = lib.mkForce 0.7;
    };
    colors = {
      background = lib.mkForce "1a1a2edd";
      text = lib.mkForce "e0e0e0ff";
      prompt = lib.mkForce "8c52ffff";
      placeholder = lib.mkForce "888888ff";
      input = lib.mkForce "e0e0e0ff";
      match = lib.mkForce "8c52ffff";
      selection = lib.mkForce "3b2964ff";
      selection-text = lib.mkForce "ffffffff";
      selection-match = lib.mkForce "bd93f9ff";
      counter = lib.mkForce "888888ff";
      border = lib.mkForce "8c52ffff";
    };
  };

  xdg.dataFile = {
    "applications/blueman-manager.desktop".text =
      hiddenDesktopEntry "Bluetooth Manager" "blueman-manager";
    "applications/blueman-adapters.desktop".text =
      hiddenDesktopEntry "Bluetooth Adapters" "blueman-adapters";
    "applications/pavucontrol.desktop".text =
      hiddenDesktopEntry "Volume Control" "pavucontrol";
    "applications/htop.desktop".text =
      hiddenDesktopEntry "Htop" "htop";
    "applications/btop.desktop".text =
      hiddenDesktopEntry "Btop" "btop";
    "applications/cmus.desktop".text =
      hiddenDesktopEntry "Cmus" "cmus";
    "applications/musikcube.desktop".text =
      hiddenDesktopEntry "Musikcube" "musikcube";
    "applications/ranger.desktop".text =
      hiddenDesktopEntry "Ranger" "ranger";
    "applications/yazi.desktop".text =
      hiddenDesktopEntry "Yazi" "yazi";
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "inode/directory" = [ "nemo.desktop" ];
      "inode/mount-point" = [ "nemo.desktop" ];
      "application/x-directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      "x-directory/normal" = [ "nemo.desktop" ];
      "x-scheme-handler/file" = [ "nemo.desktop" ];
    };
    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "inode/directory" = [ "nemo.desktop" ];
      "inode/mount-point" = [ "nemo.desktop" ];
      "application/x-directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      "x-directory/normal" = [ "nemo.desktop" ];
      "x-scheme-handler/file" = [ "nemo.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" "evince.desktop" ];
    };
  };

  dconf.settings."org/cinnamon/desktop/default-applications/terminal" = {
    exec = "${pkgs.kitty}/bin/kitty";
    exec-arg = "-e";
  };

  programs.home-manager.enable = true;
}
