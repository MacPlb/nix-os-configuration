# Option types for colors.nix. Each role needs a #rrggbb value.
{ lib, ... }:

let
  inherit (lib) mkOption types;

  hex = types.strMatching "#[0-9a-fA-F]{6}";

  colorOptions = lib.mapAttrs (
    _: description:
    mkOption {
      type = hex;
      inherit description;
    }
  );

  ansi = colorOptions {
    black = "ANSI black.";
    red = "ANSI red.";
    green = "ANSI green.";
    yellow = "ANSI yellow.";
    blue = "ANSI blue.";
    magenta = "ANSI magenta.";
    cyan = "ANSI cyan.";
    white = "ANSI white.";
  };
in
{
  options.theme = {
    name = mkOption {
      type = types.strMatching "[A-Za-z0-9_-]+";
      description = "Palette name, as shown in Noctalia's settings.";
    };

    mode = mkOption {
      type = types.enum [
        "dark"
        "light"
      ];
      description = "Whether the colors are a dark or a light scheme; GTK and Noctalia follow it.";
    };

    gnomeAccent = mkOption {
      type = types.enum [
        "blue"
        "teal"
        "green"
        "yellow"
        "orange"
        "red"
        "pink"
        "purple"
        "slate"
      ];
      description = "Closest GNOME accent preset, for libadwaita apps that ignore gtk.css.";
    };

    iconFolders = mkOption {
      type = types.str;
      example = "violet";
      description = "Papirus folder color (see papirus-folders --list).";
    };

    colors = colorOptions {
      background = "Window, terminal and editor background.";
      backgroundDark = "Darker shade of the background (Qt bevels).";
      backgroundAlt = "Alternate background (Qt mid shade, alternating list rows).";
      surface = "Raised surfaces: header bars, sidebars, popovers, inactive tabs.";
      outline = "Outlines and comments.";
      border = "Inactive window border.";
      shadow = "Shadows.";
      foreground = "Body text.";
      foregroundBright = "Emphasised text, text on the selection.";
      muted = "Disabled and placeholder text.";
      primary = "Accent: active window border, selected items, cursor, buttons.";
      onPrimary = "Text on the primary color.";
      secondary = "Second accent: links, hover.";
      tertiary = "Third accent: visited links, highlights.";
      selection = "Text selection background in the terminal and editor.";
      error = "Errors.";
    };

    terminal = {
      normal = ansi;
      bright = ansi;
    };
  };
}
