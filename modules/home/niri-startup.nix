{ config, pkgs, ... }:

{
  systemd.user.services.mpvpaper = {
    Unit = {
      Description = "Animated desktop wallpaper";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
    };
    Service = {
      ExecStart = "${pkgs.mpvpaper}/bin/mpvpaper -o 'no-audio loop-file=inf panscan=1.0 hwdec=auto' '*' ${../../static-files/wallpaper.mp4}";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };
}
