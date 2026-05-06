{ pkgs, ... }:

{
  home.username = "friedrich";
  home.homeDirectory = "/home/friedrich";
  home.stateVersion = "24.11";

  #Hyperland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {

      # Monitor layout and orientation
      monitor = [
        "HDMI-A-1, 3840x2160@120, 0x0, 1.5"
        "HDMI-A-2, 1920x1080@144, auto, 1, transform, 1"
      ];

      # Keyboard input to Polish
      input = {
        kb_layout = "pl";
        follow_mouse = 1;
        sensitivity = 0;
      };

      # Keymap Hyperland
      "$mod" = "SUPER";

      bind = [
        "$mod, Q, exec, kitty"
        "$mod, R, exec, wofi --show drun"
        "$mod, C, killactive,"
        "$mod, M, exit,"

        # Screenshoot to clipboard
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"

        #Clipboard manager
        "CTRL, grave, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
      ];

      exec-once = [
        # Waybar
        "waybar"

        # Notifications
        "mako"

        # Wallpaper demon
        "swww init"

        # Clipboard deamon
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
    };
  };

  # Mako notifications setup
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#cba6f7";
      border-radius = 10;
      border-size = 2;
      padding = "10,20";
      font = "JetBrains Mono 11";
      default-timeout = 5000;
    };
  };

  #waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
        ];

        "clock" = {
          interval = 1;
          format = "  {:%H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          on-click = "qs -p $HOME/.config/quickshell/MusicPlayer/MusicPopup.qml";
        };

        "pulseaudio" = {
          format = "  {volume}%";
          on-click = "pavucontrol";
        };

        "network" = {
          format-wifi = "  {essid}";
          format-disconnected = "󰤭 Brak";
          on-click = "~/.config/wofi/scripts/wifi.sh";
        };
      };
    };
  };

  programs.wofi.enable = true;
  programs.kitty.enable = true;

  home.packages = with pkgs; [
    grim
    slurp
    swappy
    cliphist
    wl-clipboard
    # Wallpaper package package
    swww
  ];

  # Enable HomeManager
  programs.home-manager.enable = true;
}
