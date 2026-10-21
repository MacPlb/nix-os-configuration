{ pkgs, ... }:

let
  pasteScreenshot = pkgs.writeShellApplication {
    name = "nemo-paste-screenshot";
    runtimeInputs = [
      pkgs.python3
      pkgs.wl-clipboard
      pkgs.zenity
    ];
    text = ''
      exec python3 ${./scripts/nemo-paste-screenshot.py} "$@"
    '';
  };

  videoToGif = pkgs.writeShellApplication {
    name = "nemo-video-to-gif";
    runtimeInputs = [
      pkgs.ffmpeg-full
      pkgs.libnotify
    ];
    text = ''
      for video in "$@"; do
        gif="''${video%.*}.gif"
        # ffmpeg -n exits 0 when the output exists, so check first.
        if [ -e "$gif" ]; then
          notify-send -u critical -i dialog-error "GIF not created" "$gif already exists"
          continue
        fi
        notify-send -i image-x-generic "Converting to GIF…" "$(basename "$video")"
        # 15 fps, max 960px wide, two-pass palette: small file without colour banding.
        if err=$(ffmpeg -nostdin -loglevel error -i "$video" \
          -vf "fps=15,scale='min(960,iw)':-1:flags=lanczos,split[a][b];[a]palettegen[p];[b][p]paletteuse" \
          "$gif" 2>&1); then
          notify-send -i image-x-generic "GIF ready" "$gif"
        else
          rm -f "$gif"
          notify-send -u critical -i dialog-error "GIF export failed" "$(basename "$video"): $err"
        fi
      done
    '';
  };
in
{
  xdg.dataFile."nemo/actions/paste-screenshot.nemo_action".text = ''
    [Nemo Action]
    Name=Paste Screenshot
    Comment=Save the clipboard image here; leave the filename blank for a timestamp
    Exec=${pasteScreenshot}/bin/nemo-paste-screenshot %P
    Icon-Name=edit-paste
    Selection=none
    Extensions=any;
    Quote=double
    UriScheme=file
  '';

  xdg.dataFile."nemo/actions/video-to-gif.nemo_action".text = ''
    [Nemo Action]
    Name=Convert to GIF
    Comment=Save a GIF next to each selected video
    Exec=${videoToGif}/bin/nemo-video-to-gif %F
    Icon-Name=image-x-generic
    Selection=notnone
    Mimetypes=video/*;
    Quote=double
    UriScheme=file
  '';
}
