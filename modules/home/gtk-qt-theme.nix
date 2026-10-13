{
  config,
  lib,
  pkgs,
  ...
}:

let
  # QPalette role order, including Qt 6's Accent at index 21.
  colors = [
    "#e0e0e0"
    "#2a2a3e"
    "#5c5c5c"
    "#44475a"
    "#141420"
    "#202030"
    "#e0e0e0"
    "#ffffff"
    "#e0e0e0"
    "#1a1a2e"
    "#1a1a2e"
    "#000000"
    "#8c52ff"
    "#ffffff"
    "#a77bff"
    "#bd93f9"
    "#202030"
    "#000000"
    "#2a2a3e"
    "#e0e0e0"
    "#888888"
    "#8c52ff"
  ];
  palette = pkgs.writeText "purple-qt.conf" ''
    [ColorScheme]
    active_colors=${lib.concatStringsSep ", " colors}
    inactive_colors=${lib.concatStringsSep ", " colors}
    disabled_colors=${
      lib.concatStringsSep ", " (map (color: if color == "#e0e0e0" then "#888888" else color) colors)
    }
  '';
in
{
  assertions = [
    {
      assertion = builtins.length colors == 22;
      message = "Qt palette must define all 22 color roles.";
    }
  ];
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "purple";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "violet"; };
    };

    gtk2.extraConfig = ''
      gtk-color-scheme = "selected_bg_color:#8c52ff\nselected_fg_color:#ffffff\nlink_color:#a77bff"
    '';

    gtk3.extraCss = ''
      @define-color theme_bg_color ${config.programs.kitty.settings.background};
      @define-color theme_fg_color ${config.programs.kitty.settings.foreground};
      @define-color theme_base_color @theme_bg_color;
      @define-color theme_text_color @theme_fg_color;
      @define-color theme_selected_bg_color #8c52ff;
      @define-color theme_selected_fg_color #ffffff;
      @define-color selected_bg_color @theme_selected_bg_color;
      @define-color selected_fg_color @theme_selected_fg_color;
      @define-color link_color #a77bff;
      @define-color theme_unfocused_bg_color @theme_bg_color;
      @define-color theme_unfocused_fg_color @theme_fg_color;
      @define-color theme_unfocused_base_color @theme_base_color;
      @define-color theme_unfocused_text_color @theme_text_color;
      @define-color theme_unfocused_selected_bg_color @theme_selected_bg_color;
      @define-color theme_unfocused_selected_fg_color @theme_selected_fg_color;
      @define-color accent_bg_color ${config.programs.kitty.settings.cursor};
      @define-color accent_color ${config.programs.kitty.settings.color12};
      @define-color accent_fg_color ${config.programs.kitty.settings.active_tab_foreground};
      @define-color window_bg_color @theme_bg_color;
      @define-color window_fg_color @theme_fg_color;
      @define-color view_bg_color @theme_base_color;
      @define-color view_fg_color @theme_text_color;
      @define-color headerbar_bg_color ${config.programs.kitty.settings.inactive_tab_background};
      @define-color headerbar_fg_color @theme_fg_color;
      @define-color sidebar_bg_color @headerbar_bg_color;
      @define-color sidebar_fg_color @theme_fg_color;
      @define-color card_bg_color @headerbar_bg_color;
      @define-color card_fg_color @theme_fg_color;
      @define-color dialog_bg_color @theme_bg_color;
      @define-color dialog_fg_color @theme_fg_color;
      @define-color popover_bg_color @headerbar_bg_color;
      @define-color popover_fg_color @theme_fg_color;

      /* Adwaita GTK 3 hardcodes blue in these controls. */
      selection, *:selected, check:checked, radio:checked,
      switch:checked, scale highlight, progressbar progress {
        background-color: @theme_selected_bg_color;
        background-image: none;
        color: @theme_selected_fg_color;
      }
      button.suggested-action {
        background-color: @theme_selected_bg_color;
        background-image: none;
        color: @theme_selected_fg_color;
      }
      *:focus { outline-color: @theme_selected_bg_color; }
      link, link:visited { color: @link_color; }
    '';

    gtk4.extraCss = config.gtk.gtk3.extraCss;
    gtk4.theme = config.gtk.theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "Fusion";
    qt5ctSettings.Appearance = {
      custom_palette = true;
      color_scheme_path = "${palette}";
      icon_theme = "Papirus-Dark";
    };
    qt6ctSettings = config.qt.qt5ctSettings;
  };
}
