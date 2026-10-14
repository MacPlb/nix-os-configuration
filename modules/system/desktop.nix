# Display manager, audio and the session services a graphical desktop needs.
{ config, lib, ... }:

let
  noctalia = config.home-manager.users.friedrich.programs.noctalia;
  # Shell palette keys are mCamelCase, the greeter wants snake_case (mOnPrimary -> on_primary).
  toGreeterKey =
    k:
    lib.removePrefix "m_" (builtins.replaceStrings lib.upperChars (map (c: "_" + c) lib.lowerChars) k);
in

{
  services.xserver.enable = true;

  # Noctalia Greeter on greetd; the shell syncs wallpaper, palette, font and monitor layout to it.
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "friedrich" ];
    settings = {
      session.default = "niri";
      user.default = "friedrich";
      keyboard.layout = "pl";
      # Same look as the desktop; declared here because auto-sync only fires when these change.
      appearance = {
        scheme = "Synced";
        theme_mode = noctalia.settings.theme.mode;
        font_family = noctalia.settings.shell.font_family;
        palette = lib.mapAttrs' (k: lib.nameValuePair (toGreeterKey k)) (
          removeAttrs noctalia.customPalettes.Purple.dark [ "terminal" ]
        );
        wallpaper = {
          path = noctalia.settings.wallpaper.default.path;
          # Scale to cover HDMI-A-1 and crop evenly from both sides, keeping the image centered.
          fill_mode = "crop";
        };
      };
      # Pin the login panel to the main screen instead of mirroring it.
      output.name = "HDMI-A-1";
    };
  };
  services.displayManager.defaultSession = "niri";

  system.activationScripts.hideRootFromGreeter.text = ''
        accounts_dir=/var/lib/AccountsService/users
        root_account=$accounts_dir/root

        install -d -m 0755 "$accounts_dir"
        cat > "$root_account" <<'EOF'
    [User]
    SystemAccount=true
    EOF
        chmod 0644 "$root_account"
  '';

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
}
