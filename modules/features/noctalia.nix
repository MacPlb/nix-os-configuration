# Noctalia shell as a systemd user service, plus the udiskie automounter its drive plugin uses.
# Noctalia merges every *.toml in ~/.config/noctalia in name order: config.toml from
# dotfiles/common, the host's host.toml (monitors, laptop widgets), then the generated
# theme.toml (modules/theme/apply.nix).
{ inputs, ... }:

{
  flake.nixosModules.noctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      noctalia =
        inputs.noctalia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
          (old: {
            patches = (old.patches or [ ]) ++ [ ../../patches/noctalia-track-osd.patch ];
          });

      # Pinned, patched udiskie plugin; the local plugin dir overrides the community git copy.
      udiskiePlugin = pkgs.applyPatches {
        name = "noctalia-community-plugins";
        src = pkgs.fetchFromGitHub {
          owner = "noctalia-dev";
          repo = "community-plugins";
          rev = "f62bad565c41ee37453314335a058304d42d42a5";
          hash = "sha256-idkxPyY3mOZCHCQuU9oZKXkI756GYfRgq+w7mVr/XzE=";
        };
        patches = [
          ../../patches/noctalia-udiskie-eject.patch
          ../../patches/noctalia-udiskie-quiet.patch
        ];
      };

      noctaliaFiles = lib.filterAttrs (
        rel: _: lib.hasPrefix ".config/noctalia/" rel
      ) config.dotfiles.files;

      # The settings window (and first-run setup) store [theme] in settings.toml, which wins over
      # the config files and falls back to the yellow builtin "Noctalia" palette. Drop it on every
      # start so the palette from modules/theme/colors.nix always applies; other GUI settings stay.
      stripThemeOverrides = pkgs.writeShellScript "noctalia-strip-theme-overrides" ''
        f="''${XDG_STATE_HOME:-$HOME/.local/state}/noctalia/settings.toml"
        [ -f "$f" ] || exit 0
        ${lib.getExe pkgs.gawk} '/^[[:space:]]*\[/ { skip = ($0 ~ /^[[:space:]]*\[[[:space:]]*theme[[:space:]]*[].]/) } !skip' "$f" > "$f.tmp"
        mv "$f.tmp" "$f"
      '';
    in
    {
      imports = [ inputs.noctalia-shell.nixosModules.default ];

      programs.noctalia = {
        enable = true;
        package = noctalia;
        systemd.enable = true;
      };

      systemd.user.services.noctalia.serviceConfig.ExecStartPre = [ stripThemeOverrides ];

      dotfiles.files.".local/share/noctalia/plugins/udiskie" = "${udiskiePlugin}/udiskie";

      # The udiskie plugin shells out to udiskie-info/-mount/-umount.
      environment.systemPackages = [ pkgs.udiskie ];

      # No --notify: the plugin already notifies, udiskie's own popups would duplicate them.
      systemd.user.services.udiskie = {
        description = "udiskie mount daemon";
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${lib.getExe' pkgs.udiskie "udiskie"} --automount --no-notify --no-tray";
          Restart = "on-failure";
        };
      };

      environment.shellAliases.noctalia-restart = "systemctl --user restart noctalia.service";

      # Fail the build, not the session, on an invalid shell config.
      system.checks = [
        (pkgs.runCommand "noctalia-config-check" { } ''
          export HOME=$TMPDIR
          ${lib.concatStrings (
            lib.mapAttrsToList (rel: source: ''
              install -D -m 644 ${source} noctalia/${lib.removePrefix ".config/noctalia/" rel}
            '') noctaliaFiles
          )}
          ${lib.getExe noctalia} config validate noctalia
          touch $out
        '')
      ];
    };
}
