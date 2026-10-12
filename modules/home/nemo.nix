{ pkgs, ... }:

let
  pasteScreenshot = pkgs.writeShellApplication {
    name = "nemo-paste-screenshot";
    runtimeInputs = [ pkgs.python3 pkgs.wl-clipboard pkgs.zenity ];
    text = ''
      exec python3 ${./scripts/nemo-paste-screenshot.py} "$@"
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
}
