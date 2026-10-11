{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.clipse ];

  programs.niri.settings = {
    spawn-at-startup = [
      {
        command = [
          "${pkgs.wl-clipboard}/bin/wl-paste"
          "--type"
          "text"
          "--watch"
          "${pkgs.clipse}/bin/clipse"
          "-wl-store"
        ];
      }
      {
        command = [
          "${pkgs.wl-clipboard}/bin/wl-paste"
          "--type"
          "image"
          "--watch"
          "${pkgs.clipse}/bin/clipse"
          "-wl-store"
        ];
      }
    ];

    window-rules = lib.mkAfter [
      {
        matches = [
          { app-id = "^clipse$"; }
        ];
        open-floating = true;
        open-focused = true;
        default-column-width.fixed = 900;
        default-window-height.fixed = 520;
        default-floating-position = {
          relative-to = "top";
          x = 0;
          y = 460;
        };
      }
    ];
  };
}
