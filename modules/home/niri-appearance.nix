{ ... }:

{
  programs.niri.settings = {
    gestures.hot-corners.enable = false;

    # Prefer server-side decorations for a cleaner look
    prefer-no-csd = true;

    # Disable hotkey cheatsheet overlay on login
    hotkey-overlay.skip-at-startup = true;

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
        active.color = "#8c52ff";
        inactive.color = "#5c5c5c";
      };

      focus-ring.enable = false;
    };

    # Lets Noctalia notification actions focus the window that sent them.
    debug.honor-xdg-activation-with-invalid-serial = [ ];

    # Noctalia's blurred wallpaper copy fills the overview background.
    layer-rules = [
      {
        matches = [ { namespace = "^noctalia-backdrop"; } ];
        place-within-backdrop = true;
      }
    ];

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
      {
        matches = [ { app-id = "^dev\\.noctalia\\.Noctalia$"; } ];
        open-floating = true;
        default-column-width.fixed = 1080;
        default-window-height.fixed = 920;
      }
    ];
  };
}
