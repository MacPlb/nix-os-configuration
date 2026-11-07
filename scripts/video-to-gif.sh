# Nautilus action: save a GIF next to each selected video.
for video in "$@"; do
  # Strip the extension from the file name only, so /a.b/clip doesn't become /a.gif.
  case "${video##*/}" in
    *.*) gif="${video%.*}.gif" ;;
    *) gif="$video.gif" ;;
  esac
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
