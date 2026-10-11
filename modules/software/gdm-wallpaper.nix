{ ... }:

let
  wallpaper = ../../static-files/wallpaper.jpg;
in
{
  # The GDM login screen ignores the dconf background settings: gnome-shell
  # paints it with a solid colour from #lockDialogGroup in its built-in theme.
  # Patch that theme so the login screen shows our wallpaper instead.
  nixpkgs.overlays = [
    (final: prev: {
      gnome-shell = prev.gnome-shell.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          resource=$out/share/gnome-shell/gnome-shell-theme.gresource
          prefix=/org/gnome/shell/theme
          workdir=$(mktemp -d)

          for file in $(${final.glib.dev}/bin/gresource list "$resource"); do
            mkdir -p "$workdir/$(dirname "''${file#$prefix/}")"
            ${final.glib.dev}/bin/gresource extract "$resource" "$file" > "$workdir/''${file#$prefix/}"
          done

          for css in gnome-shell-dark.css gnome-shell-light.css; do
            cat >> "$workdir/$css" <<'EOF'

          #lockDialogGroup {
            background: #1a1a2e url("file://${wallpaper}");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
          }
          EOF
          done

          {
            echo '<?xml version="1.0" encoding="UTF-8"?>'
            echo "<gresources><gresource prefix=\"$prefix\">"
            (cd "$workdir" && find . -type f -printf '%P\n' | sort | sed 's|.*|<file>&</file>|')
            echo '</gresource></gresources>'
          } > "$workdir/theme.gresource.xml"

          ${final.buildPackages.glib.dev}/bin/glib-compile-resources \
            --sourcedir="$workdir" --target="$resource" "$workdir/theme.gresource.xml"
        '';
      });
    })
  ];
}
