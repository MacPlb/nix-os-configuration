# Writes the color files for each app from colors.nix, plus the Qt palette and GSettings.
# The generated files sit next to the hand-written dotfiles, which include them.
{ config, ... }:

let
  inherit (config) theme;
  c = theme.colors;
  t = theme.terminal;
in
{
  flake.nixosModules.theme =
    { lib, pkgs, ... }:
    let
      dark = theme.mode == "dark";
      gtkTheme = if dark then "Adwaita-dark" else "Adwaita";
      iconTheme = if dark then "Papirus-Dark" else "Papirus-Light";

      gtkSettings = pkgs.writeText "gtk-settings.ini" ''
        [Settings]
        gtk-theme-name=${gtkTheme}
        gtk-icon-theme-name=${iconTheme}
        gtk-application-prefer-dark-theme=${lib.boolToString dark}
      '';

      qtct = pkgs.writeText "qtct.conf" ''
        [Appearance]
        style=Fusion
        custom_palette=true
        icon_theme=${iconTheme}
        color_scheme_path=/etc/xdg/qt5ct/colors/theme.conf
      '';

      ansi = with t; [
        normal.black
        normal.red
        normal.green
        normal.yellow
        normal.blue
        normal.magenta
        normal.cyan
        normal.white
        bright.black
        bright.red
        bright.green
        bright.yellow
        bright.blue
        bright.magenta
        bright.cyan
        bright.white
      ];

      kitty = pkgs.writeText "kitty-theme.conf" ''
        background ${c.background}
        foreground ${c.foreground}
        cursor ${c.primary}
        cursor_text_color ${c.background}
        selection_background ${c.selection}
        selection_foreground ${c.foregroundBright}
        url_color ${c.primary}
        active_tab_background ${c.primary}
        active_tab_foreground ${c.onPrimary}
        inactive_tab_background ${c.surface}
        inactive_tab_foreground ${c.muted}
        ${lib.concatImapStringsSep "\n" (i: color: "color${toString (i - 1)} ${color}") ansi}
      '';

      niri = pkgs.writeText "niri-theme.kdl" ''
        layout {
            border {
                active-color "${c.primary}"
                inactive-color "${c.border}"
            }
        }
      '';

      # Read by gtk.css (@import), which keeps the style rules.
      gtkColors = pkgs.writeText "gtk-colors.css" ''
        @define-color theme_bg_color ${c.background};
        @define-color theme_fg_color ${c.foreground};
        @define-color theme_selected_bg_color ${c.primary};
        @define-color theme_selected_fg_color ${c.onPrimary};
        @define-color link_color ${c.secondary};
        @define-color accent_bg_color ${c.primary};
        @define-color accent_color ${c.secondary};
        @define-color accent_fg_color ${c.onPrimary};
        @define-color headerbar_bg_color ${c.surface};
      '';

      # GTK 2 has no include for colors, so the whole file is generated.
      gtk2 = pkgs.writeText "gtkrc-2.0" ''
        gtk-theme-name = "${gtkTheme}"
        gtk-icon-theme-name = "${iconTheme}"
        gtk-color-scheme = "selected_bg_color:${c.primary}\nselected_fg_color:${c.onPrimary}\nlink_color:${c.secondary}"
      '';

      # QPalette roles in order, including Qt 6's Accent (index 21). Disabled text is muted.
      qtPalette =
        text:
        lib.concatStringsSep ", " [
          text # WindowText
          c.surface # Button
          c.border # Light
          c.outline # Midlight
          c.backgroundDark # Dark
          c.backgroundAlt # Mid
          text # Text
          c.foregroundBright # BrightText
          text # ButtonText
          c.background # Base
          c.background # Window
          c.shadow # Shadow
          c.primary # Highlight
          c.onPrimary # HighlightedText
          c.secondary # Link
          c.tertiary # LinkVisited
          c.backgroundAlt # AlternateBase
          c.shadow # NoRole
          c.surface # ToolTipBase
          text # ToolTipText
          c.muted # PlaceholderText
          c.primary # Accent
        ];
      qt = pkgs.writeText "qt-colors.conf" ''
        [ColorScheme]
        active_colors=${qtPalette c.foreground}
        inactive_colors=${qtPalette c.foreground}
        disabled_colors=${qtPalette c.muted}
      '';

      # Noctalia custom palette: Material-style roles plus the terminal colors.
      noctaliaPalette = pkgs.writeText "noctalia-palette.json" (
        builtins.toJSON {
          ${theme.mode} = {
            mPrimary = c.primary;
            mOnPrimary = c.onPrimary;
            mSecondary = c.secondary;
            mOnSecondary = c.background;
            mTertiary = c.tertiary;
            mOnTertiary = c.background;
            mError = c.error;
            mOnError = c.background;
            mSurface = c.background;
            mOnSurface = c.foreground;
            mSurfaceVariant = c.surface;
            mOnSurfaceVariant = c.foreground;
            mOutline = c.outline;
            mShadow = c.shadow;
            mHover = c.secondary;
            mOnHover = c.background;
            terminal = {
              background = c.background;
              foreground = c.foreground;
              cursor = c.primary;
              cursorText = c.background;
              selectionBg = c.selection;
              selectionFg = c.foregroundBright;
              inherit (t) normal bright;
            };
          };
        }
      );

      # Sorted after config.toml and host.toml, so it sets the palette last.
      noctaliaTheme = (pkgs.formats.toml { }).generate "noctalia-theme.toml" {
        theme = {
          inherit (theme) mode;
          source = "custom";
          custom_palette = theme.name;
        };
      };

      # Zellij's UI components; it loads every file in ~/.config/zellij/themes and config.kdl
      # picks this one by name.
      zellijComponent = name: base: background: ''
        ${name} {
          base "${base}"
          background "${background}"
          emphasis_0 "${t.bright.cyan}"
          emphasis_1 "${t.bright.green}"
          emphasis_2 "${c.tertiary}"
          emphasis_3 "${t.bright.red}"
        }
      '';
      zellij = pkgs.writeText "zellij-theme.kdl" ''
        themes {
          system {
            ${lib.concatStrings [
              (zellijComponent "text_unselected" c.foreground c.backgroundDark)
              (zellijComponent "text_selected" c.foregroundBright c.selection)
              (zellijComponent "ribbon_selected" c.onPrimary c.primary)
              (zellijComponent "ribbon_unselected" c.foreground c.surface)
              (zellijComponent "table_title" c.primary c.background)
              (zellijComponent "table_cell_selected" c.foregroundBright c.selection)
              (zellijComponent "table_cell_unselected" c.foreground c.backgroundDark)
              (zellijComponent "list_selected" c.foregroundBright c.selection)
              (zellijComponent "list_unselected" c.foreground c.backgroundDark)
              (zellijComponent "frame_selected" c.primary c.background)
              (zellijComponent "frame_unselected" c.border c.background)
              (zellijComponent "frame_highlight" c.secondary c.background)
              (zellijComponent "exit_code_success" t.normal.green c.background)
              (zellijComponent "exit_code_error" c.error c.background)
            ]}
            multiplayer_user_colors {
              ${lib.concatImapStringsSep "\n" (i: color: "player_${toString i} \"${color}\"") (
                lib.take 10 (lib.drop 1 ansi)
              )}
            }
          }
        }
      '';

      # base16 roles for mini.base16 plus the extra highlights init.lua sets.
      nvim = pkgs.writeText "nvim-theme.lua" ''
        return {
          base16 = {
            base00 = "${c.background}",
            base01 = "${c.surface}",
            base02 = "${c.selection}",
            base03 = "${c.outline}",
            base04 = "${c.muted}",
            base05 = "${c.foreground}",
            base06 = "${t.normal.white}",
            base07 = "${t.bright.white}",
            base08 = "${t.normal.red}",
            base09 = "${t.bright.red}",
            base0A = "${t.normal.yellow}",
            base0B = "${t.normal.green}",
            base0C = "${t.normal.cyan}",
            base0D = "${t.normal.blue}",
            base0E = "${t.normal.magenta}",
            base0F = "${t.bright.magenta}",
          },
          cursor = { fg = "${c.background}", bg = "${c.primary}" },
          visual = { fg = "${c.foregroundBright}", bg = "${c.selection}" },
        }
      '';
    in
    {
      environment.systemPackages = with pkgs; [
        gnome-themes-extra # Adwaita and Adwaita-dark for GTK 2/3
        adwaita-icon-theme
        (papirus-icon-theme.override { color = theme.iconFolders; })
        nixos-icons # snowflake for Noctalia's control center button
      ];

      # qt5ct/qt6ct read ~/.config/qt5ct and ~/.config/qt6ct (Fusion style, colors below).
      qt = {
        enable = true;
        platformTheme = "qt5ct";
      };

      # Locked, so values left in the user's dconf database (e.g. GNOME's accent color on the
      # laptop, installed with GNOME) can't override them.
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            color-scheme = "prefer-${theme.mode}";
            accent-color = theme.gnomeAccent;
            gtk-theme = gtkTheme;
            icon-theme = iconTheme;
          };
          locks = map (key: "/org/gnome/desktop/interface/${key}") [
            "color-scheme"
            "accent-color"
            "gtk-theme"
            "icon-theme"
          ];
        }
      ];

      # Stable paths, so the dotfiles contain neither store paths nor a user's home directory.
      environment.etc = {
        "backgrounds/wallpaper.png".source = ../../static-files/wallpaper.png;
        "xdg/qt5ct/colors/theme.conf".source = qt;
      };

      dotfiles.files = {
        ".config/kitty/theme.conf" = kitty;
        ".config/niri/theme.kdl" = niri;
        ".config/gtk-3.0/colors.css" = gtkColors;
        ".config/gtk-4.0/colors.css" = gtkColors;
        ".config/gtk-3.0/settings.ini" = gtkSettings;
        ".config/gtk-4.0/settings.ini" = gtkSettings;
        ".config/qt5ct/qt5ct.conf" = qtct;
        ".config/qt6ct/qt6ct.conf" = qtct;
        ".gtkrc-2.0" = gtk2;
        ".config/noctalia/palettes/${theme.name}.json" = noctaliaPalette;
        ".config/noctalia/theme.toml" = noctaliaTheme;
        ".config/nvim/lua/theme.lua" = nvim;
        ".config/zellij/themes/system.kdl" = zellij;
      };
    };
}
