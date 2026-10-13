{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.niri.settings = {
    binds =
      let
        spawn = cmd: { action.spawn = cmd; };
        noctalia =
          cmd:
          spawn (
            [
              (lib.getExe config.programs.noctalia.package)
              "msg"
            ]
            ++ cmd
          );
        workspaceBinds = builtins.listToAttrs (
          builtins.concatMap (
            workspace:
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
            ]
          ) (builtins.genList (index: index + 1) 10)
        );
      in
      {
        "Mod+Q" = spawn [ "${pkgs.kitty}/bin/kitty" ];
        "Mod+Return" = spawn [ "${pkgs.kitty}/bin/kitty" ];
        "Mod+E" = spawn [ "${pkgs.nemo-with-extensions}/bin/nemo" ];
        "Mod+F1" = spawn [ "${pkgs.nemo-with-extensions}/bin/nemo" ];
        "Mod+R" = noctalia [
          "panel-toggle"
          "launcher"
        ];
        "Mod+Space" = noctalia [
          "panel-toggle"
          "launcher"
        ];
        "Ctrl+L" = noctalia [
          "session"
          "lock"
        ];
        "Mod+B" = spawn [ "${pkgs.firefox}/bin/firefox" ];

        "Mod+C" = {
          action.close-window = [ ];
        };
        "Mod+Shift+E" = {
          action.quit = [ ];
        };

        "Print" = noctalia [ "screenshot-region" ];
        "Mod+Print" = noctalia [ "screenshot-annotate" ];
        "Shift+Print" = noctalia [ "screenshot-fullscreen" ];
        "Mod+Shift+Print" = {
          action.screenshot-window = [ ];
        };
        "Mod+Shift+R" = noctalia [
          "plugin"
          "noctalia/screen_recorder:service"
          "all"
          "toggle"
        ];
        "Ctrl+Grave" = noctalia [
          "panel-toggle"
          "clipboard"
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
          action.focus-workspace-up = [ ];
        };
        "Mod+Down" = {
          action.focus-workspace-down = [ ];
        };
        "Mod+Ctrl+Up" = {
          action.move-column-to-workspace-up = [ ];
        };
        "Mod+Ctrl+Down" = {
          action.move-column-to-workspace-down = [ ];
        };
        "Mod+Ctrl+K" = {
          action.move-column-to-workspace-up = [ ];
        };
        "Mod+Ctrl+J" = {
          action.move-column-to-workspace-down = [ ];
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
        "Mod+M" = {
          action.focus-monitor-next = [ ];
        };
        "Mod+Shift+M" = {
          action.move-column-to-monitor-next = [ ];
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

        "Mod+Escape" = noctalia [
          "session"
          "lock"
        ];

        "XF86AudioRaiseVolume" = noctalia [ "volume-up" ];
        "XF86AudioLowerVolume" = noctalia [ "volume-down" ];
        "XF86AudioMute" = noctalia [ "volume-mute" ];
        "XF86AudioPlay" = noctalia [
          "media"
          "toggle"
        ];
        "XF86AudioNext" = noctalia [
          "media"
          "next"
        ];
        "XF86AudioPrev" = noctalia [
          "media"
          "previous"
        ];
        "XF86MonBrightnessUp" = noctalia [ "brightness-up" ];
        "XF86MonBrightnessDown" = noctalia [ "brightness-down" ];
      }
      // workspaceBinds;
  };
}
