# The color scheme: the only file that contains colors. Change a value and rebuild; kitty,
# niri, Neovim, Zellij, GTK 2/3/4, Qt 5/6, Noctalia and the login greeter all follow
# (modules/theme/apply.nix writes their color files). `make check` fails on a hex color
# anywhere else in modules/ or dotfiles/, so nothing can drift out of sync.
#
# Every value is checked against modules/theme/options.nix, which documents each role.
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
