# Everyday desktop apps and terminal utilities.
{
  flake.nixosModules.apps =
    { pkgs, ... }:
    {
      # Rhythmbox plugins, including MPRIS for Noctalia's media widget.
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/rhythmbox/plugins".active-plugins = [
            "generic-player"
            "mpris"
            "ipod"
            "power-manager"
            "rb"
            "artsearch"
            "cd-recorder"
            "mtpdevice"
            "dbus-media-server"
            "iradio"
            "audiocd"
            "audioscrobbler"
            "android"
          ];
        }
      ];

      # LocalSend; also opens its firewall port (53317).
      programs.localsend.enable = true;

      environment.systemPackages = with pkgs; [
        # GUI apps
        keepassxc
        firefox
        thunderbird
        vesktop
        unstable.signal-desktop
        rhythmbox
        obsidian
        evince
        libreoffice-fresh
        hunspell
        hunspellDicts.en_US
        hunspellDicts.pl_PL
        zotero

        # Desktop integration
        shared-mime-info

        # University / system tools
        baobab
        gnome-disk-utility
        gnome-system-monitor
        simple-scan
        loupe
        file-roller
        system-config-printer
        gnome-calculator

        # Terminal utilities
        btop
        htop
        fastfetch
        file
        tree
        eza
        fd
        fzf
        jq
        yq
        sd
        tldr
        zoxide
        unzip
        p7zip
        duf
        dust
        ncdu
        glow
        chafa
        yazi
        lf
        ranger
        cmus
        musikcube
        yt-dlp
      ];
    };
}
