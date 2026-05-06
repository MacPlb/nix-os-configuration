{ pkgs, inputs, ... }:

{
  home.username = "friedrich";
  home.homeDirectory = "/home/friedrich";
  home.stateVersion = "24.11";

  # Niri Wayland compositor configuration
  programs.niri.settings = {
    # Prefer server-side decorations for a cleaner look
    prefer-no-csd = true;

    # Monitor layout and orientation
    outputs = {
      "HDMI-A-1" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 120.0;
        };
        scale = 1.5;
        position = { x = 0; y = 0; };
      };
      "HDMI-A-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 144.0;
        };
        scale = 1.0;
        transform.rotation = 90;
        position = { x = 2560; y = 0; };
      };
    };

    # Keyboard input — Polish layout
    input = {
      keyboard.xkb.layout = "pl";
      mouse.accel-speed = 0.0;
    };

    # Keybindings
    binds = let
      spawn = cmd: { action.spawn = cmd; };
    in {
      # Terminal
      "Mod+Q"       = spawn [ "kitty" ];

      # Application launcher
      "Mod+R"       = spawn [ "wofi" "--show" "drun" ];

      # Close focused window
      "Mod+C"       = { action.close-window = []; };

      # Quit Niri
      "Mod+M"       = { action.quit = []; };

      # Screenshot region to clipboard via swappy
      "Print"       = spawn [ "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -" ];

      # Clipboard manager
      "Ctrl+Grave"  = spawn [ "sh" "-c" "cliphist list | wofi --dmenu | cliphist decode | wl-copy" ];

      # Window focus
      "Mod+Left"    = { action.focus-column-left = []; };
      "Mod+Right"   = { action.focus-column-right = []; };
      "Mod+Up"      = { action.focus-window-up = []; };
      "Mod+Down"    = { action.focus-window-down = []; };

      # Move windows
      "Mod+Shift+Left"  = { action.move-column-left = []; };
      "Mod+Shift+Right" = { action.move-column-right = []; };

      # Workspace navigation
      "Mod+1" = { action.focus-workspace = 1; };
      "Mod+2" = { action.focus-workspace = 2; };
      "Mod+3" = { action.focus-workspace = 3; };
      "Mod+4" = { action.focus-workspace = 4; };
      "Mod+5" = { action.focus-workspace = 5; };

      # Move window to workspace
      "Mod+Shift+1" = { action.move-column-to-workspace = 1; };
      "Mod+Shift+2" = { action.move-column-to-workspace = 2; };
      "Mod+Shift+3" = { action.move-column-to-workspace = 3; };
      "Mod+Shift+4" = { action.move-column-to-workspace = 4; };
      "Mod+Shift+5" = { action.move-column-to-workspace = 5; };
    };

    # Programs launched when Niri starts
    spawn-at-startup = [
      # Noctalia desktop shell (bar, notifications, widgets)
      { command = [ "noctalia-shell" ]; }

      # Wallpaper daemon
      { command = [ "swww" "init" ]; }

      # Clipboard history daemons
      { command = [ "wl-paste" "--type" "text" "--watch" "cliphist" "store" ]; }
      { command = [ "wl-paste" "--type" "image" "--watch" "cliphist" "store" ]; }
    ];
  };

  programs.wofi.enable = true;
  programs.kitty.enable = true;

  # Enable HomeManager
  programs.home-manager.enable = true;
}
