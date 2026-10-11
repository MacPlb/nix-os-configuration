{ pkgs,  pkgs-unstable,... }:

{
  environment.systemPackages = with pkgs; [
    # GUI apps
    keepassxc
    firefox
    thunderbird
    vesktop
    pkgs-unstable.signal-desktop
    rhythmbox
    evince
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    hunspellDicts.pl_PL
    zotero

    # Desktop integration
    adwaita-icon-theme
    papirus-icon-theme
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
    brightnessctl
    file
    tree
    eza
    fd
    fzf
    jq
    yq
    ripgrep
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

    # Wayland/Xwayland compatibility
    xwayland-satellite

    # Clipboard manager with image preview support
    clipse
  ];
}
