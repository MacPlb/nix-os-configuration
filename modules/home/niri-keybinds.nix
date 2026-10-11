{ pkgs, ... }:

{
  programs.niri.settings = {
    binds =
      let
        spawn = cmd: { action.spawn = cmd; };
        workspaceBinds =
          builtins.listToAttrs (
            builtins.concatMap
              (workspace:
                let
                  key = if workspace == 10 then "0" else builtins.toString workspace;
                in
                [
                  {
                    name = "Mod+${key}";
                    value.action.focus-workspace = workspace;
                  }
                  {
                    name = "Mod+Shift+${key}";
                    value.action.move-column-to-workspace = workspace;
                  }
                ])
              (builtins.genList (index: index + 1) 10)
          );
      in
      {
        "Mod+Q" = spawn [ "kitty" ];
        "Mod+Return" = spawn [ "kitty" ];
        "Mod+E" = spawn [ "nemo" ];
        "Mod+F1" = spawn [ "nemo" ];
        "Mod+R" = spawn [ "fuzzel" ];
        "Mod+Space" = spawn [ "fuzzel" ];
        "Ctrl+L" = spawn [ "${pkgs.gdm}/bin/gdmflexiserver" ];
        "Mod+B" = spawn [ "firefox" ];
        "Mod+V" = spawn [
          "${pkgs.kitty}/bin/kitty"
          "--class"
          "clipse"
          "--title"
          "Clipboard"
          "-e"
          "clipse"
        ];

        "Mod+C" = {
          action.close-window = [ ];
        };
        "Mod+Shift+E" = {
          action.quit = [ ];
        };

        "Print" = spawn [
          "sh"
          "-c"
          "grim -g \"$(slurp)\" - | wl-copy --type image/png"
        ];
        "Mod+Print" = spawn [
          "sh"
          "-c"
          "grim -g \"$(slurp)\" - | swappy -f -"
        ];
        "Shift+Print" = spawn [
          "sh"
          "-c"
          "grim - | wl-copy --type image/png"
        ];
        "Mod+Shift+Print" = spawn [
          "sh"
          "-c"
          "niri msg action screenshot-window --write-to-disk false && wl-paste --type image/png | swappy -f -"
        ];
        "Ctrl+Grave" = spawn [
          "${pkgs.kitty}/bin/kitty"
          "--class"
          "clipse"
          "--title"
          "Clipboard"
          "-e"
          "clipse"
        ];

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

        "Mod+F" = {
          action.fullscreen-window = [ ];
        };
        "Mod+Shift+F" = {
          action.maximize-column = [ ];
        };
        "Mod+O" = {
          action.toggle-overview = [ ];
        };
        "Mod+W" = {
          action.switch-preset-column-width = [ ];
        };
        "Mod+Shift+Space" = {
          action.toggle-window-floating = [ ];
        };

        "Mod+Minus" = {
          action.set-column-width = "-10%";
        };
        "Mod+Equal" = {
          action.set-column-width = "+10%";
        };

        "Mod+Tab" = {
          action.focus-monitor-right = [ ];
        };
        "Mod+Shift+Tab" = {
          action.focus-monitor-left = [ ];
        };

        "Mod+Comma" = {
          action.consume-window-into-column = [ ];
        };
        "Mod+Period" = {
          action.expel-window-from-column = [ ];
        };
        "Mod+BracketLeft" = {
          action.consume-or-expel-window-left = [ ];
        };
        "Mod+BracketRight" = {
          action.consume-or-expel-window-right = [ ];
        };
        "Mod+Shift+Slash" = {
          action.show-hotkey-overlay = [ ];
        };

        "Mod+Escape" = spawn [ "${pkgs.gdm}/bin/gdmflexiserver" ];

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
        "XF86MonBrightnessUp" = spawn [
          "brightnessctl"
          "set"
          "5%+"
        ];
        "XF86MonBrightnessDown" = spawn [
          "brightnessctl"
          "set"
          "5%-"
        ];
      }
      // workspaceBinds;
  };
}
