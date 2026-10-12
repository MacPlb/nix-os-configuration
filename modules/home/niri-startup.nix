{ config, pkgs, ... }:

{
  systemd.user.services.awww = {
    Unit = {
      Description = "Static desktop wallpaper";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
    };
    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      ExecStartPost = pkgs.writeShellScript "set-wallpaper" ''
        until ${pkgs.awww}/bin/awww query >/dev/null 2>&1; do
          ${pkgs.coreutils}/bin/sleep 0.1
        done
        exec ${pkgs.awww}/bin/awww img --transition-type none ${../../static-files/wallpaper.png}
      '';
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };
}
