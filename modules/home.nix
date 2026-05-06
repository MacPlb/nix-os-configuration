{ config, pkgs, ... }:

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
          kb_layout  = "pl";
          follow_mouse = 1;
          sensitivity  = 0;
        };

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
          "swww init"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
        ];
      };
    };

  #waybar
  programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };

      settings = {
        mainBar = {
          output = [ "HDMI-A-1" ];
          layer = "top";
          position = "top";
          margin = "6 15 0 15";
          spacing = 6;

          # --- MODULES LAYOUT ---
          modules-left = [ "custom/nixos" "clock#date" "tray" "hyprland/workspaces" "mpris" ];
          modules-center = [ "clock" ];
          modules-right = [ "cpu" "memory" "temperature" "backlight" "pulseaudio" "network" "bluetooth" "battery" "custom/power" ];

          # --- MODULES CONFIGURATION ---
          "custom/nixos" = {
            format = "";
            tooltip = false;
            on-click = "pkill wofi || wofi --show drun";
          };

          # Separate module for the date on the left side
          "clock#date" = {
            format = "  {:%d %B %Y}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
          };

          "tray" = {
            spacing = 8;
          };

          "hyprland/workspaces" = {
            format = "{icon}";
            on-click = "activate";
            format-icons = {
              "1" = ""; "2" = ""; "3" = ""; "4" = ""; "5" = "";
              "urgent" = ""; "active" = ""; "default" = "";
            };
          };

          "mpris" = {
            format = "{player_icon} {dynamic}";
            format-paused = "{status_icon} <i>{dynamic}</i>";
            player-icons = { "default" = "▶"; "spotify" = ""; };
            status-icons = { "paused" = ""; };
            max-length = 35;
          };

          # Clock in the center with seconds
          "clock" = {
            interval = 1; # Refresh every second!
            format = "  {:%H:%M:%S}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
          };

          "cpu" = {
            format = "  {usage}%";
            tooltip = false;
          };

          # RAM showing exact usage in GB
          "memory" = {
            interval = 5;
            format = "  {used:0.1f}GB / {total:0.1f}GB";
          };

          "temperature" = {
            critical-threshold = 80;
            format = "{icon} {temperatureC}°C";
            format-icons = ["" "" ""];
          };

          "backlight" = {
            format = "{icon} {percent}%";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          };

          # Clicking opens Pavucontrol (I/O device selection)
          "pulseaudio" = {
            format = "{icon}  {volume}%";
            format-muted = "  Muted";
            format-icons = { default = [ "" "" "" ]; };
            on-click = "pavucontrol";
          };

          # Network shows SSID, clicking opens nmtui in kitty
          "network" = {
            format-wifi = "   {essid}";
            format-ethernet = "󰈀   Connected";
            format-disconnected = "⚠ Disconnected";
            tooltip-format = "Signal strength: {signalStrength}%";
            on-click = "kitty -e nmtui"; # Opens network selection in the terminal
          };

          # Bluetooth
          "bluetooth" = {
            format = " {status}";
            format-connected = " Connected";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            on-click = "blueman-manager"; # Opens Bluetooth manager
          };

          "battery" = {
            states = { warning = 30; critical = 15; };
            format = "{icon}  {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-icons = ["" "" "" "" ""];
          };

          "custom/power" = {
            format = "";
            tooltip = false;
            on-click = "wlogout";
          };
        };
      };

      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", "FiraCode Nerd Font", sans-serif;
          /* Reduced font size by approx. 20% (from 15px to 12px) */
          font-size: 12px;
          min-height: 0;
        }

        window#waybar {
          background-color: transparent;
        }

        /* Reduced padding and margins of the pills */
        #workspaces, #mpris, #window, #clock, #cpu, #memory, #temperature, #backlight, #pulseaudio, #network, #bluetooth, #battery, #tray, #custom-nixos, #custom-power {
          background-color: #1e1e2e;
          color: #cdd6f4;
          border-radius: 12px; /* Smaller border-radius adapted to the size */
          padding: 2px 12px; /* Previously 4px 16px */
          margin-top: 3px;   /* Previously 5px */
          margin-bottom: 3px;
          box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.3);
        }

        #custom-nixos { color: #89b4fa; font-size: 16px; padding-right: 15px; }
        #workspaces button { color: #6c7086; padding: 0 4px; }
        #workspaces button.active { color: #a6e3a1; }
        #workspaces button:hover { color: #f9e2af; box-shadow: none; text-shadow: none; background: transparent; }
        #mpris { color: #cba6f7; }
        #clock { color: #fab387; font-weight: bold; }
        #cpu { color: #f38ba8; }
        #memory { color: #fab387; }
        #temperature { color: #f9e2af; }
        #temperature.critical { background-color: #f38ba8; color: #11111b; }
        #backlight { color: #f9e2af; }
        #pulseaudio { color: #89b4fa; }
        #network { color: #a6e3a1; }
        #bluetooth { color: #74c7ec; }
        #battery { color: #a6e3a1; }
        #battery.warning { color: #fab387; }
        #battery.critical:not(.charging) { background-color: #f38ba8; color: #11111b; }
        #custom-power { color: #f38ba8; padding-left: 12px; padding-right: 12px; }
      '';
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
    nerdfonts
  ];

  programs.home-manager.enable = true;
}
