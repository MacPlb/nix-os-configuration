# Shell, nh and command-line basics.
{ inputs, ... }:

{
  flake.nixosModules.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.nh = {
        enable = true;
        flake = "/etc/nixos";
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };
      };

      # Prompt for bash; the config is dotfiles/common/.config/starship.toml.
      programs.starship.enable = true;

      environment.systemPackages = with pkgs; [
        # Extra GNU tools; coreutils, grep, sed, tar, less etc. are in the base system.
        parallel
        wget
        gnupg
        gnumake
        binutils
        texinfo

        # Lists every shell alias, generated from environment.shellAliases across all modules.
        (pkgs.writeShellScriptBin "nixhelp" ''
          {
          ${
            lib.concatStrings (
              lib.mapAttrsToList (
                name: value: "printf '%s\\t%s\\n' ${lib.escapeShellArg name} ${lib.escapeShellArg value}\n"
              ) (lib.filterAttrs (_: value: value != null) config.environment.shellAliases)
            )
          }} | ${pkgs.util-linux}/bin/column -t -s "$(printf '\t')"
        '')

        # Updates flake.lock in the repo (every input, or only the ones named), then installs
        # the repo to /etc/nixos and switches; nh prints which package versions changed.
        (pkgs.writeShellScriptBin "nixupdate" ''
          set -euo pipefail

          if [ "''${1:-}" = -h ] || [ "''${1:-}" = --help ]; then
            echo "usage: nixupdate [input...]   (run inside the repo, or set NIXOS_REPO)"
            echo "  no inputs: update all of them; inputs: ${
              lib.concatStringsSep " " (lib.attrNames (builtins.removeAttrs inputs [ "self" ]))
            }"
            exit 0
          fi

          # The repo is NIXOS_REPO or the nearest directory above $PWD with flake.nix and a Makefile.
          repo=''${NIXOS_REPO:-$PWD}
          while [ ! -f "$repo/flake.nix" ] || [ ! -f "$repo/Makefile" ]; do
            if [ "$repo" = / ]; then
              echo "nixupdate: run it inside the configuration repo or set NIXOS_REPO" >&2
              exit 1
            fi
            repo=$(dirname "$repo")
          done
          cd "$repo"

          nix flake update "$@"
          make install
          nh os switch
        '')
      ];

      # nh builds nixosConfigurations.<hostname> from NH_FLAKE (set by programs.nh.flake).
      environment.shellAliases = {
        nixswitch = "nh os switch";
        nixtest = "nh os test";
        nixboot = "nh os boot";

        nixgc = "nh clean all";
        nixclean = "nh clean all --keep-since 7d --keep 3";
        nixopt = "nix-store --optimise";

        nshell = "nix-shell -p";
        nsearch = "nix search nixpkgs";
        nrun = "nix run";
        cls = "clear";
      };
    };
}
