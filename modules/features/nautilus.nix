# Nautilus file manager, "Open in Terminal" for kitty, and the right-click actions in
# scripts/nautilus-actions.py with the helpers behind them.
{
  flake.nixosModules.nautilus =
    { lib, pkgs, ... }:
    let
      pasteScreenshot = pkgs.writeShellApplication {
        name = "paste-screenshot";
        runtimeInputs = [
          pkgs.python3
          pkgs.wl-clipboard
          pkgs.zenity
        ];
        text = ''
          exec python3 ${../../scripts/paste-screenshot.py} "$@"
        '';
      };

      videoToGif = pkgs.writeShellApplication {
        name = "video-to-gif";
        runtimeInputs = [
          pkgs.ffmpeg-full
          pkgs.libnotify
        ];
        text = builtins.readFile ../../scripts/video-to-gif.sh;
      };

      # nautilus-python loads extensions from share/nautilus-python/extensions in XDG_DATA_DIRS.
      actions = pkgs.runCommand "nautilus-file-actions" { } ''
        install -Dm444 ${
          pkgs.replaceVars ../../scripts/nautilus-actions.py {
            pasteScreenshot = lib.getExe pasteScreenshot;
            videoToGif = lib.getExe videoToGif;
          }
        } $out/share/nautilus-python/extensions/file-actions.py
      '';
    in
    {
      # Also installs nautilus-python and points Nautilus at its extension directory.
      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };

      environment.systemPackages = [
        pkgs.nautilus
        actions
      ];
    };
}
