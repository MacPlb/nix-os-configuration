{ pkgs, ... }:

{
  # ----- GTK dark theme with purple accent -----
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraCss = ''
      @define-color accent_bg_color #8c52ff;
      @define-color accent_color #8c52ff;
      @define-color accent_fg_color #ffffff;
    '';

    gtk4.extraCss = ''
      @define-color accent_bg_color #8c52ff;
      @define-color accent_color #8c52ff;
      @define-color accent_fg_color #ffffff;
    '';
  };

  # ----- Qt follows GTK dark theme -----
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
}
