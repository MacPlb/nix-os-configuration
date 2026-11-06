# Kitty as the default terminal; its config is dotfiles/common/.config/kitty/kitty.conf.
{
  flake.nixosModules.kitty =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.kitty ];

      xdg.terminal-exec = {
        enable = true;
        settings.default = [ "kitty.desktop" ];
      };

      environment.variables.TERMINAL = "kitty";
    };
}
