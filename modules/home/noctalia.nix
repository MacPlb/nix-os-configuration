{ inputs, pkgs, ... }:

{
  imports = [ inputs.noctalia-shell.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font";
        clipboard_enabled = false; # Clipse owns clipboard history.
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
          hide_when_no_media = true;
          max_length = 800; # noctalia maximum
        };
        tray = {
          drawer = false;
          hidden = [ "nm-applet" "blueman" "blueman-applet" ];
        };
      };

      dock.enabled = false;
      notification.position = "top_center";
      theme = {
        mode = "dark";
        source = "wallpaper";
        builtin = "Noctalia";
      };
      location = {
        auto_locate = false;
        address = "Bytow, Poland";
        latitude = 54.1706;
        longitude = 17.4919;
      };

      # mpvpaper renders the video; the still frame supplies theme colors.
      wallpaper = {
        enabled = false;
        default.path = "${../../static-files/wallpaper.jpg}";
      };
    };
  };
}
