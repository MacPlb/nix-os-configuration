# Color scheme. This is the only file that should contain hex values; modules/theme/apply.nix
# writes the per-app color files from it, and `make check` rejects hex colors elsewhere.
#
# The option types are in modules/theme/options.nix.
{
  theme = {
    name = "Purple";
    mode = "dark";

    # Names, not hex: GNOME's nearest accent preset and the Papirus folder color.
    gnomeAccent = "purple";
    iconFolders = "violet";

    colors = {
      background = "#1a1a2e";
      backgroundDark = "#141420";
      backgroundAlt = "#202030";
      surface = "#2a2a3e";
      outline = "#44475a";
      border = "#5c5c5c";
      shadow = "#000000";

      foreground = "#e0e0e0";
      foregroundBright = "#ffffff";
      muted = "#888888";

      primary = "#8c52ff";
      onPrimary = "#ffffff";
      secondary = "#a77bff";
      tertiary = "#bd93f9";
      selection = "#3b2964";
      error = "#ff5555";
    };

    # ANSI colors (kitty color0–color15); Neovim's syntax colors come from these too.
    terminal = {
      normal = {
        black = "#1a1a2e";
        red = "#ff5555";
        green = "#50fa7b";
        yellow = "#bd93f9";
        blue = "#8c52ff";
        magenta = "#bd93f9";
        cyan = "#8be9fd";
        white = "#e0e0e0";
      };
      bright = {
        black = "#44475a";
        red = "#ff6e6e";
        green = "#69ff94";
        yellow = "#d6acff";
        blue = "#a77bff";
        magenta = "#d6acff";
        cyan = "#a4ffff";
        white = "#ffffff";
      };
    };
  };
}
