{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=14";
        prompt = "❯ ";
        terminal = "${pkgs.kitty}/bin/kitty";
        lines = 15;
        width = 60;
        horizontal-pad = 20;
        vertical-pad = 20;
        inner-pad = 10;
        image-size-ratio = 0.5;
        tabs = 4;
      };
      colors = {
        background = "1a1a2edd";
        text = "e0e0e0ff";
        match = "8c52ffff";
        selection = "3b2964ff";
        selection-text = "ffffffff";
        selection-match = "8c52ffff";
        border = "8c52ffff";
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
