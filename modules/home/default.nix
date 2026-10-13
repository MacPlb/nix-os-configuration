{ pkgs, lib, ... }:

let
  hiddenDesktopEntry = name: exec: ''
    [Desktop Entry]
    Type=Application
    Name=${name}
    Exec=${exec}
    NoDisplay=true
  '';

  # Map every MIME type in `types` to the given desktop entries.
  assoc = apps: types: lib.genAttrs types (_: apps);

  defaultApps = lib.mkMerge [
    (assoc [ "firefox.desktop" ] [
      "text/html"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ])
    (assoc [ "nemo.desktop" ] [
      "inode/directory"
      "inode/mount-point"
      "application/x-directory"
      "application/x-gnome-saved-search"
      "x-directory/normal"
      "x-scheme-handler/file"
    ])
    (assoc [ "thunderbird.desktop" ] [
      "x-scheme-handler/mailto"
      "message/rfc822"
      "text/calendar"
    ])
    (assoc [ "org.gnome.Evince.desktop" ] [
      "application/pdf"
      "application/postscript"
      "image/vnd.djvu"
      "application/epub+zip"
    ])
    (assoc [ "nvim.desktop" ] [
      "text/plain"
      "text/markdown"
      "text/x-csrc"
      "text/x-chdr"
      "text/x-c++src"
      "text/x-python"
      "text/x-go"
      "text/rust"
      "text/x-shellscript"
      "text/x-nix"
      "application/x-shellscript"
      "application/json"
      "application/toml"
      "application/x-yaml"
      "application/xml"
      "text/xml"
      "text/css"
      "text/javascript"
      "application/javascript"
      "text/x-log"
    ])
    (assoc [ "org.gnome.Loupe.desktop" ] [
      "image/png"
      "image/jpeg"
      "image/gif"
      "image/webp"
      "image/bmp"
      "image/tiff"
      "image/svg+xml"
      "image/avif"
      "image/heic"
      "image/x-icon"
    ])
    (assoc [ "mpv.desktop" ] [
      "video/mp4"
      "video/x-matroska"
      "video/webm"
      "video/quicktime"
      "video/x-msvideo"
      "video/mpeg"
      "video/ogg"
      "video/x-flv"
      "audio/mpeg"
      "audio/flac"
      "audio/ogg"
      "audio/opus"
      "audio/wav"
      "audio/x-wav"
      "audio/aac"
      "audio/mp4"
      "audio/x-m4a"
    ])
    (assoc [ "org.gnome.FileRoller.desktop" ] [
      "application/zip"
      "application/x-7z-compressed"
      "application/x-tar"
      "application/gzip"
      "application/x-compressed-tar"
      "application/x-bzip2-compressed-tar"
      "application/x-xz-compressed-tar"
      "application/zstd"
      "application/x-zstd-compressed-tar"
      "application/vnd.rar"
      "application/x-rar"
    ])
    (assoc [ "writer.desktop" ] [
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/msword"
      "application/vnd.oasis.opendocument.text"
      "application/rtf"
    ])
    (assoc [ "calc.desktop" ] [
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.ms-excel"
      "application/vnd.oasis.opendocument.spreadsheet"
      "text/csv"
    ])
    (assoc [ "impress.desktop" ] [
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/vnd.ms-powerpoint"
      "application/vnd.oasis.opendocument.presentation"
    ])
    (assoc [ "signal.desktop" ] [ "x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha" ])
    (assoc [ "vesktop.desktop" ] [ "x-scheme-handler/discord" ])
  ];
in
{
  home.username = "friedrich";
  home.homeDirectory = "/home/friedrich";
  home.stateVersion = "24.11";

  imports = [
    ./niri-keybinds.nix
    ./niri-appearance.nix
    ./niri-outputs.nix
    ./nemo.nix
    ./noctalia.nix
    ./kitty.nix
    ./gtk-qt-theme.nix
    ./starship.nix
    ./neovim.nix
  ];

  services.udiskie = {
    enable = true;
    automount = true;
    tray = "never";
  };

  xdg.desktopEntries.nemo = {
    name = "Files";
    genericName = "File Manager";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo %U";
    icon = "system-file-manager";
    terminal = false;
    categories = [
      "GNOME"
      "GTK"
      "Utility"
      "Core"
      "System"
      "FileManager"
    ];
    mimeType = [
      "inode/directory"
      "inode/mount-point"
      "application/x-directory"
      "application/x-gnome-saved-search"
      "x-directory/normal"
      "x-scheme-handler/file"
    ];
  };

  xdg.dataFile = {
    "applications/htop.desktop".text =
      hiddenDesktopEntry "Htop" "htop";
    "applications/btop.desktop".text =
      hiddenDesktopEntry "Btop" "btop";
    "applications/cmus.desktop".text =
      hiddenDesktopEntry "Cmus" "cmus";
    "applications/musikcube.desktop".text =
      hiddenDesktopEntry "Musikcube" "musikcube";
    "applications/ranger.desktop".text =
      hiddenDesktopEntry "Ranger" "ranger";
    "applications/yazi.desktop".text =
      hiddenDesktopEntry "Yazi" "yazi";
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = defaultApps;
    defaultApplications = defaultApps;
  };

  # Nemo "Open in Terminal": schema org.cinnamon.desktop.default-applications.terminal
  # lives at dconf path /org/cinnamon/desktop/applications/terminal/
  dconf.settings."org/cinnamon/desktop/applications/terminal" = {
    exec = "${pkgs.kitty}/bin/kitty";
    exec-arg = "-e";
  };

  dconf.settings."org/gnome/rhythmbox/plugins".active-plugins = [
    "generic-player" "mpris" "ipod" "power-manager" "rb" "artsearch"
    "cd-recorder" "mtpdevice" "dbus-media-server" "iradio" "audiocd"
    "audioscrobbler" "android"
  ];

  programs.home-manager.enable = true;
}
