{ ... }:

{
  programs.niri.settings = {
    debug.wait-for-frame-completion-before-queueing = [ ];
    # shortcut: avoids scanout format/bandwidth changes, remove after AMD artifacts are resolved upstream.
    debug.restrict-primary-scanout-to-matching-format = [ ];
    outputs = {
      "HDMI-A-1" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 120.0;
        };
        scale = 1.5;
        position = {
          x = 0;
          y = 0;
        };
      };
      "HDMI-A-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 120.0;
        };
        scale = 1.0;
        transform.rotation = 90;
        position = {
          x = 2560;
          y = 0;
        };
      };
    };
  };
}
