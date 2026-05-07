{ pkgs, inputs, ... }:

{
  home.username = "friedrich";
  home.homeDirectory = "/home/friedrich";
  home.stateVersion = "24.11";

  # Niri Wayland compositor configuration
  programs.niri.settings = {
    # Prefer server-side decorations for a cleaner look
    prefer-no-csd = true;

    # Monitor layout and orientation
    outputs = {
      "HDMI-A-1" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 120.0;
        };
        scale = 1.5;
        position = {
          x = 0;
          y = 0;
        };
      };
      "HDMI-A-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 144.0;
        };
        scale = 1.0;
        transform.rotation = 90;
        position = {
          x = 2560;
          y = 0;
        };
      };
    };

    # Keyboard input — Polish layout
    input = {
      keyboard.xkb.layout = "pl";
      mouse.accel-speed = 0.0;
    };

    # ----- Animations (Niri defaults with slight speedup) -----
    animations.slowdown = 0.8;

    # ----- Layout: gaps, borders, no focus ring -----
    layout = {
      gaps = 12;
      center-focused-column = "never";
      default-column-width = {
        proportion = 0.5;
      };

      border = {
        enable = true;
        width = 2;
      };

      focus-ring.enable = false;
    };

    # ----- Window rules: rounded corners -----
    window-rules = [
      {
        geometry-corner-radius =
          let
            r = 8.0;
          in
          {
            bottom-left = r;
            bottom-right = r;
            top-left = r;
            top-right = r;
          };
        clip-to-geometry = true;
      }
    ];


    # ----- Keybindings -----
    binds =
      let
        spawn = cmd: { action.spawn = cmd; };
      in
      {
        # Terminal
        "Mod+Q" = spawn [ "kitty" ];

        # Application launcher (Noctalia built-in)
        "Mod+R" = spawn [
          "noctalia-shell"
          "ipc"
          "call"
          "launcher"
          "toggle"
        ];

        # Close focused window
        "Mod+C" = {
          action.close-window = [ ];
        };

        # Quit Niri
        "Mod+M" = {
          action.quit = [ ];
        };

        # Screenshot region to clipboard via swappy
        "Print" = spawn [
          "sh"
          "-c"
          "grim -g \"$(slurp)\" - | swappy -f -"
        ];

        # Clipboard manager
        "Ctrl+Grave" = spawn [
          "sh"
          "-c"
          "cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        ];

        # ----- Vim-style window focus (h/j/k/l) -----
        "Mod+H" = {
          action.focus-column-left = [ ];
        };
        "Mod+L" = {
          action.focus-column-right = [ ];
        };
        "Mod+K" = {
          action.focus-window-up = [ ];
        };
        "Mod+J" = {
          action.focus-window-down = [ ];
        };

        # Arrow-key focus (kept for convenience)
        "Mod+Left" = {
          action.focus-column-left = [ ];
        };
        "Mod+Right" = {
          action.focus-column-right = [ ];
        };
        "Mod+Up" = {
          action.focus-window-up = [ ];
        };
        "Mod+Down" = {
          action.focus-window-down = [ ];
        };

        # ----- Vim-style window move -----
        "Mod+Shift+H" = {
          action.move-column-left = [ ];
        };
        "Mod+Shift+L" = {
          action.move-column-right = [ ];
        };
        "Mod+Shift+K" = {
          action.move-window-up = [ ];
        };
        "Mod+Shift+J" = {
          action.move-window-down = [ ];
        };

        # Arrow-key move (kept for convenience)
        "Mod+Shift+Left" = {
          action.move-column-left = [ ];
        };
        "Mod+Shift+Right" = {
          action.move-column-right = [ ];
        };

        # Move to monitor
        "Mod+Shift+Control+Left" = {
          action.move-column-to-monitor-left = [ ];
        };
        "Mod+Shift+Control+Right" = {
          action.move-column-to-monitor-right = [ ];
        };
        "Mod+Shift+Control+Up" = {
          action.move-column-to-monitor-up = [ ];
        };
        "Mod+Shift+Control+Down" = {
          action.move-column-to-monitor-down = [ ];
        };

        # Fullscreen toggle
        "Mod+F" = {
          action.fullscreen-window = [ ];
        };

        # Resize column width
        "Mod+Minus" = {
          action.set-column-width = "-10%";
        };
        "Mod+Equal" = {
          action.set-column-width = "+10%";
        };

        # Workspace navigation
        "Mod+1" = {
          action.focus-workspace = 1;
        };
        "Mod+2" = {
          action.focus-workspace = 2;
        };
        "Mod+3" = {
          action.focus-workspace = 3;
        };
        "Mod+4" = {
          action.focus-workspace = 4;
        };
        "Mod+5" = {
          action.focus-workspace = 5;
        };

        # Move window to workspace
        "Mod+Shift+1" = {
          action.move-column-to-workspace = 1;
        };
        "Mod+Shift+2" = {
          action.move-column-to-workspace = 2;
        };
        "Mod+Shift+3" = {
          action.move-column-to-workspace = 3;
        };
        "Mod+Shift+4" = {
          action.move-column-to-workspace = 4;
        };
        "Mod+Shift+5" = {
          action.move-column-to-workspace = 5;
        };

        # Lock screen
        "Mod+Escape" = spawn [
          "swaylock"
          "--effect-blur"
          "7x5"
          "--clock"
          "--indicator"
        ];

        # ----- Volume / media keys -----
        "XF86AudioRaiseVolume" = spawn [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "5%+"
        ];
        "XF86AudioLowerVolume" = spawn [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "5%-"
        ];
        "XF86AudioMute" = spawn [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];
        "XF86AudioPlay" = spawn [
          "playerctl"
          "play-pause"
        ];
        "XF86AudioNext" = spawn [
          "playerctl"
          "next"
        ];
        "XF86AudioPrev" = spawn [
          "playerctl"
          "previous"
        ];
      };

    # Programs launched when Niri starts
    spawn-at-startup = [
      # Video wallpaper (loops, no audio)
      {
        command = [
          "mpvpaper"
          "-o"
          "no-audio loop --panscan=1.0"
          "*"
          "/etc/nixos/wallpaper.mp4"
        ];
      }

      # Noctalia desktop shell (bar, notifications, widgets)
      { command = [ "noctalia-shell" ]; }

      # Clipboard history daemons
      {
        command = [
          "wl-paste"
          "--type"
          "text"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        command = [
          "wl-paste"
          "--type"
          "image"
          "--watch"
          "cliphist"
          "store"
        ];
      }
    ];
  };

  programs.kitty.enable = true;

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

  # Enable HomeManager
  programs.home-manager.enable = true;
}
