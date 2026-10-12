{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      # Dark background matching the desktop palette
      background = "#1a1a2e";
      foreground = "#e0e0e0";
      background_opacity = "0.92";

      # Purple cursor matching Niri border (#8c52ff)
      cursor = "#8c52ff";
      cursor_text_color = "#1a1a2e";

      # Selection colors
      selection_background = "#3b2964";
      selection_foreground = "#ffffff";

      # Window chrome
      window_padding_width = 8;
      confirm_os_window_close = 0;

      # Tab bar
      tab_bar_style = "powerline";
      active_tab_background = "#8c52ff";
      active_tab_foreground = "#ffffff";
      inactive_tab_background = "#2a2a3e";
      inactive_tab_foreground = "#888888";

      # URL color
      url_color = "#8c52ff";

      # Terminal colors (dark palette with purple tones)
      color0  = "#1a1a2e";
      color1  = "#ff5555";
      color2  = "#50fa7b";
      color3  = "#bd93f9";
      color4  = "#8c52ff";
      color5  = "#bd93f9";
      color6  = "#8be9fd";
      color7  = "#e0e0e0";
      color8  = "#44475a";
      color9  = "#ff6e6e";
      color10 = "#69ff94";
      color11 = "#d6acff";
      color12 = "#a77bff";
      color13 = "#d6acff";
      color14 = "#a4ffff";
      color15 = "#ffffff";
    };
  };
}
