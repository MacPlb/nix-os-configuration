# Niri compositor from nixpkgs. Its config is dotfiles/common/.config/niri/config.kdl, which
# includes the generated theme.kdl and the host's dotfiles/<hostname>/.config/niri/host.kdl.
{
  flake.nixosModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      niriFiles = lib.filterAttrs (rel: _: lib.hasPrefix ".config/niri/" rel) config.dotfiles.files;
    in
    {
      programs.niri.enable = true;
      # niri-session runs a bare `systemctl --user import-environment`, which systemd warns is
      # deprecated; pass the variable names explicitly. Wrapped instead of overrideAttrs so niri
      # isn't recompiled.
      programs.niri.package = pkgs.symlinkJoin {
        inherit (pkgs.niri)
          pname
          version
          passthru
          meta
          ;
        paths = [ pkgs.niri ];
        postBuild = ''
          rm $out/bin/niri-session
          sed 's|systemctl --user import-environment$|systemctl --user import-environment $(awk '"'"'BEGIN{for(v in ENVIRON) if (v != "AWKPATH" \&\& v != "AWKLIBPATH") print v}'"'"')|' \
            ${pkgs.niri}/bin/niri-session > $out/bin/niri-session
          chmod +x $out/bin/niri-session
          grep -q 'import-environment \$(awk' $out/bin/niri-session
        '';
      };
      # File dialogs come from the GTK portal (below), so the GNOME portal doesn't need Nautilus.
      programs.niri.useNautilus = false;

      # Electron / Chromium apps should use Wayland natively
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      # programs.niri sets the niri portal preferences (GNOME for screencasting, GTK otherwise).
      xdg.portal = {
        config.common.default = [ "gtk" ];
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      # Backend for the noctalia/screen_recorder plugin.
      programs.gpu-screen-recorder.enable = true;

      environment.systemPackages = with pkgs; [
        # Clipboard CLI (Nautilus screenshot paste, neovim); history lives in Noctalia
        wl-clipboard
        # X11 apps; niri starts it on demand
        xwayland-satellite
      ];

      assertions = [
        {
          assertion = niriFiles ? ".config/niri/host.kdl";
          message = "niri's config.kdl includes host.kdl; add dotfiles/${config.networking.hostName}/.config/niri/host.kdl.";
        }
      ];

      # Fail the build, not the login, on a broken niri config.
      system.checks = [
        (pkgs.runCommand "niri-config-check" { } ''
          mkdir niri
          ${lib.concatStrings (
            lib.mapAttrsToList (rel: source: ''
              cp ${source} niri/${lib.removePrefix ".config/niri/" rel}
            '') niriFiles
          )}
          ${lib.getExe config.programs.niri.package} validate -c niri/config.kdl
          touch $out
        '')
      ];
    };
}
