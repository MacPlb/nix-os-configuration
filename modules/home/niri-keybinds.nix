{ ... }:

{
  programs.niri.settings = {
    # ----- Keybindings -----
    binds =
      let
        spawn = cmd: { action.spawn = cmd; };
      in
      {
        # Terminal
        "Mod+Q" = spawn [ "kitty" ];

        # File manager
        "Mod+E" = spawn [ "nautilus" ];

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
        "Mod+Shift+E" = {
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
          "cliphist list | fuzzel -d | cliphist decode | wl-copy"
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
          action.toggle-overview = [ ];
        };
        "Mod+Down" = {
          action.close-window = [ ];
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
        "Mod+Shift+Up" = {
          action.move-window-up = [ ];
        };
        "Mod+Shift+Down" = {
          action.move-window-down = [ ];
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

        # Maximize column
        "Mod+Shift+F" = {
          action.maximize-column = [ ];
        };

        # Workspace overview
        "Mod+O" = {
          action.toggle-overview = [ ];
        };

        # Cycle preset column widths
        "Mod+W" = {
          action.switch-preset-column-width = [ ];
        };

        # Resize column width
        "Mod+Minus" = {
          action.set-column-width = "-10%";
        };
        "Mod+Equal" = {
          action.set-column-width = "+10%";
        };

        # Monitor Navigation
        "Mod+Tab" = {
          action.focus-monitor-right = [ ];
        };
        "Mod+Shift+Tab" = {
          action.focus-monitor-left = [ ];
        };

        # Splitting / Column Control
        "Mod+Comma" = {
          action.consume-window-into-column = [ ];
        };
        "Mod+Period" = {
          action.expel-window-from-column = [ ];
        };

        # Show bindings
        "Mod+Shift+Slash" = {
          action.show-hotkey-overlay = [ ];
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
  };
}
