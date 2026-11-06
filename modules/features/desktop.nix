# The graphical session: Noctalia Greeter, audio, polkit, removable media, plus the features
# every desktop host gets (Niri, Noctalia, theme, kitty, Nautilus).
{
  config,
  inputs,
  self,
  ...
}:

let
  inherit (config) theme;
in
{
  flake.nixosModules.desktop =
    { config, lib, ... }:
    let
      inherit (config.my) user;

      # The greeter copies the shell's look; read font and wallpaper from the shell's own config.
      shellConfig = lib.importTOML config.dotfiles.files.".config/noctalia/config.toml";
    in
    {
      imports = [
        inputs.noctalia-greeter.nixosModules.default
        self.nixosModules.theme
        self.nixosModules.niri
        self.nixosModules.noctalia
        self.nixosModules.kitty
        self.nixosModules.nautilus
      ];

      services.xserver.enable = true;

      # Noctalia Greeter on greetd; the shell syncs wallpaper, palette, font and monitor layout to it.
      services.displayManager.noctalia-greeter = {
        enable = true;
        passwordless-sync-users = [ user ];
        settings = {
          session.default = "niri";
          user.default = user;
          keyboard.layout = config.services.xserver.xkb.layout;
          # Same look as the desktop; declared here because auto-sync only fires when these change.
          appearance = {
            scheme = "Synced";
            theme_mode = theme.mode;
            font_family = shellConfig.shell.font_family;
            palette = with theme.colors; {
              primary = primary;
              on_primary = onPrimary;
              secondary = secondary;
              on_secondary = background;
              tertiary = tertiary;
              on_tertiary = background;
              error = error;
              on_error = background;
              surface = background;
              on_surface = foreground;
              surface_variant = surface;
              on_surface_variant = foreground;
              outline = outline;
              shadow = shadow;
              hover = secondary;
              on_hover = background;
            };
            wallpaper = {
              path = shellConfig.wallpaper.default.path;
              # Scale to cover the screen and crop evenly from both sides, keeping the image centered.
              fill_mode = "crop";
            };
          };
        };
      };
      services.displayManager.defaultSession = "niri";

      # Keep root out of the greeter's user list.
      systemd.tmpfiles.settings."10-hide-root-from-greeter" = {
        "/var/lib/AccountsService/users".d.mode = "0755";
        "/var/lib/AccountsService/users/root"."f+" = {
          mode = "0644";
          argument = "[User]\nSystemAccount=true\n";
        };
      };

      programs.dconf.enable = true;
      programs.xwayland.enable = true;

      security.rtkit.enable = true;
      security.polkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      services.gvfs.enable = true;
      services.udisks2.enable = true;
      services.blueman.enable = false;
    };
}
