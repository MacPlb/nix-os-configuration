# Display manager, audio and the session services a graphical desktop needs.
{ ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";
  services.greetd.enable = false;

  system.activationScripts.hideRootFromGdm.text = ''
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
  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          icon-theme = "Papirus-Dark";
          accent-color = "purple";
        };
      };
    }
  ];

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
