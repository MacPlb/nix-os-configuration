{ config, inputs, pkgs, ... }:

let
  kitty = config.programs.kitty.settings;
in

{
  imports = [ inputs.noctalia-shell.homeModules.default ];

  programs.noctalia.customPalettes.Purple.dark = {
    mPrimary = kitty.cursor;
    mOnPrimary = kitty.active_tab_foreground;
    mSecondary = kitty.color12;
    mOnSecondary = kitty.background;
    mTertiary = kitty.color5;
    mOnTertiary = kitty.background;
    mError = kitty.color1;
    mOnError = kitty.background;
    mSurface = kitty.background;
    mOnSurface = kitty.foreground;
    mSurfaceVariant = kitty.inactive_tab_background;
    mOnSurfaceVariant = kitty.foreground;
    mOutline = kitty.color8;
    mShadow = "#000000";
    mHover = kitty.color12;
    mOnHover = kitty.background;
    terminal = {
      background = kitty.background;
      foreground = kitty.foreground;
      cursor = kitty.cursor;
      cursorText = kitty.cursor_text_color;
      selectionBg = kitty.selection_background;
      selectionFg = kitty.selection_foreground;
      normal = {
        black = kitty.color0;
        red = kitty.color1;
        green = kitty.color2;
        yellow = kitty.color5;
        blue = kitty.color4;
        magenta = kitty.color5;
        cyan = kitty.color6;
        white = kitty.color7;
      };
      bright = {
        black = kitty.color8;
        red = kitty.color9;
        green = kitty.color10;
        yellow = kitty.color13;
        blue = kitty.color12;
        magenta = kitty.color13;
        cyan = kitty.color14;
        white = kitty.color15;
      };
    };
  };

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./patches/noctalia-track-osd.patch ];
    });
    systemd.enable = true;

    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font";
        clipboard_enabled = false; # Clipse owns clipboard history.
        panel = {
          control_center_placement = "attached";
          launcher_placement = "attached";
          clipboard_placement = "attached";
          wallpaper_placement = "attached";
          session_placement = "attached";
          open_near_click_control_center = true;
          open_near_click_launcher = true;
          open_near_click_clipboard = true;
          open_near_click_wallpaper = true;
          open_near_click_session = true;
        };
        launcher.pinned = [
          "firefox"
          "nemo"
          "kitty"
          "thunderbird"
          "signal"
          "vesktop"
          "org.keepassxc.KeePassXC"
          "org.gnome.Evince"
        ];
      };

      bar.main = {
        position = "top";
        background_opacity = 0.0;
        compositor_blur = false;
        capsule = true;
        margin_ends = 0;
        margin_edge = 0;
        # Bars spawn on every monitor; hide this one on the vertical screen.
        monitor."HDMI-A-2".enabled = false;
        start = [ "control-center" "workspaces" "media" ];
        center = [ "clock" ];
        end = [ "tray" "volume" "bluetooth" "network" "network_rx" "network_tx" "session" ];
      };

      widget = {
        # Noctalia 5 shows its owl by default; use the NixOS logo instead.
        control-center.custom_image =
          "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        clock.format = "{:%H:%M:%S}";
        workspaces = {
          hide_when_empty = true;
          label_source = "id";
        };
        media = {
          show_tooltip = false;
          hide_when_no_media = true;
          max_length = 800; # noctalia maximum
        };
        tray = {
          drawer = false;
          hidden = [ "nm-applet" "blueman" "blueman-applet" ];
        };
      };

      control_center.sidebar_section = "none";
      dock.enabled = false;
      notification = {
        position = "top_center";
        monitors = [ "HDMI-A-1" ];
        follow_focused_output = false;
      };
      osd = {
        monitors = [ "HDMI-A-1" ];
        follow_focused_output = false;
      };
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "Purple";
      };
      location = {
        auto_locate = false;
        address = "Bytow, Poland";
        latitude = 54.1706;
        longitude = 17.4919;
      };

      # awww renders the wallpaper.
      wallpaper = {
        enabled = false;
        default.path = "${../../static-files/wallpaper.png}";
      };
    };
  };
}
