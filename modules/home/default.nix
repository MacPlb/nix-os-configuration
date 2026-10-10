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

  home.file.".config/noctalia/settings.json" = {
    force = lib.mkForce true;
    text = lib.mkForce (builtins.toJSON {
      bar = {
        position = "top";
        barType = "simple";
        backgroundOpacity = 0.0;
        useSeparateOpacity = true;
        showCapsule = true;
        font = "JetBrainsMono Nerd Font";
        monitors = [ "HDMI-A-1" ];

        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
              enableColorization = false;
            }
            {
              id = "Workspace";
              hideUnoccupied = true;
              labelMode = "index";
            }
            {
              id = "MediaMini";
              hideMode = "hidden";
              showAlbumArt = true;
              showVisualizer = true;
              maxWidth = 1000;
            }
          ];
          center = [
            {
              id = "Clock";
              formatHorizontal = "HH:mm:ss";
            }
          ];
          right = [
            {
              id = "Tray";
              drawerEnabled = false;
              blacklist = [
                "nm-applet"
                "blueman"
                "blueman-applet"
              ];
            }
            {
              id = "Volume";
              displayMode = "alwaysShow";
            }
            { id = "Bluetooth"; }
            {
              id = "WiFi";
              displayMode = "alwaysShow";
            }
            {
              id = "SystemMonitor";
              compactMode = false;
              monospaceFont = true;
              padText = false;
              showCpuUsage = false;
              showCpuFrequency = false;
              showCpuTemp = false;
              showLoadAverage = false;
              showMemoryUsage = false;
              showSwapUsage = false;
              showNetworkStats = true;
              showDiskUsage = false;
            }
            { id = "SessionMenu"; }
          ];
        };
      };

      appLauncher = {
        pinnedApps = [
          "firefox.desktop"
          "nemo.desktop"
          "kitty.desktop"
          "thunderbird.desktop"
          "signal.desktop"
          "vesktop.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "org.gnome.Evince.desktop"
        ];
        terminalCommand = "kitty -e";
        screenshotAnnotationTool = "swappy -f";
      };

      dock = {
        enable = false;
        position = "bottom";
        monitors = [ "HDMI-A-1" ];
        pinnedApps = [
          "firefox.desktop"
          "nemo.desktop"
          "kitty.desktop"
          "thunderbird.desktop"
          "signal.desktop"
          "vesktop.desktop"
          "org.keepassxc.KeePassXC.desktop"
        ];
      };

      general = {
        enableBlurBehind = false;
        notifications = {
          position = "topCenter";
          blacklist = [ ];
        };
      };

      colorSchemes = {
        useWallpaperColors = true;
        darkMode = true;
        predefinedScheme = "Noctalia (default)";
      };

      location = {
        autoLocate = false;
        address = "Bytow, Poland";
        latitude = 54.1706;
        longitude = 17.4919;
      };

      wallpaper = {
        enabled = false;
      };
    });
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
