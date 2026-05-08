{ ... }:

{
  home.file.".config/noctalia/settings.json" = {
    force = true;
    text = builtins.toJSON {
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

      dock = {
        enable = true;
        position = "bottom";
        monitors = [ "HDMI-A-1" ];
      };

      general = {
        enableBlurBehind = false;
        notifications = {
          position = "topCenter";
        };
      };

      colorSchemes = {
        useWallpaperColors = true;
        darkMode = true;
        predefinedScheme = "Noctalia (default)";
      };

      location = {
        autoLocate = true;
      };

      wallpaper = {
        enabled = false;
      };
    };
  };
}
