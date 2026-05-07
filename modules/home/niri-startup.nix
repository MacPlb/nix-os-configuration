{ pkgs, ... }:

{
  programs.niri.settings = {
    spawn-at-startup = [
      # Video wallpaper (loops, no audio)
      {
        command = [
          "mpvpaper"
          "-o"
          "no-audio loop --panscan=1.0"
          "*"
          "/etc/nixos/wallpaper.mp4"
        ];
      }

      # Noctalia desktop shell (bar, notifications, widgets)
      { command = [ "noctalia-shell" ]; }

      # Clipboard history daemons
      {
        command = [
          "wl-paste"
          "--type"
          "text"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        command = [
          "wl-paste"
          "--type"
          "image"
          "--watch"
          "cliphist"
          "store"
        ];
      }
    ];
  };
}
