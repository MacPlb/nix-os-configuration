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
    let
      aliases = lib.filterAttrs (_: value: value != null) config.environment.shellAliases;

      # Column width for the names in nixhelp, so both sections line up.
      width = lib.foldl' lib.max 0 (
        map lib.stringLength (lib.attrNames config.my.commands ++ lib.attrNames aliases)
      );

      rows =
        attrs:
        lib.concatStrings (
          lib.mapAttrsToList (name: text: ''
            row ${lib.escapeShellArg name} ${lib.escapeShellArg text}
          '') attrs
        );
    in
    {
      options.my.commands = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = {
          nixupdate = "Update flake inputs and switch";
        };
        description = "Commands this configuration adds and a one-line description of each, listed by nixhelp.";
      };

      config.my.commands = {
        nixhelp = "List these commands and every shell alias";
        nixupdate = "Update flake inputs (all, or the ones named), install to /etc/nixos and switch";
      };

      config.programs.nh = {
        enable = true;
        flake = "/etc/nixos";
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };
      };

      # Prompt for bash; the config is dotfiles/common/.config/starship.toml.
      config.programs.starship.enable = true;

      # Ctrl+T pastes a fuzzy-picked file, Alt+C cds into a picked directory.
      config.programs.fzf.keybindings = true;
      # `z <part of a path>` jumps to the most used matching directory; `zi` picks interactively.
      config.programs.zoxide.enable = true;
      # Searchable shell history in a local SQLite database: Ctrl+R (and Up) open the search.
      # Nothing leaves the machine unless you run `atuin login`.
      config.programs.atuin.enable = true;

      config.environment.systemPackages = with pkgs; [
        # Extra GNU tools; coreutils, grep, sed, tar, less etc. are in the base system.
        parallel
        wget
        gnupg
        gnumake
        binutils
        texinfo

        # Modern CLI tools
        fd # find replacement
        jq # JSON
        yq-go # YAML/TOML/XML, jq syntax
        fzf
        eza # ls with git status and tree view
        lazygit # git TUI
        gh # GitHub CLI: PRs, issues, `gh auth login`
        xh # HTTP requests: `xh POST :5000/api name=x`
        just # project command runner (justfile)

        # Lists my.commands and every shell alias (environment.shellAliases across all modules).
        (pkgs.writeShellScriptBin "nixhelp" ''
          # Colors only on a terminal, and never with NO_COLOR set.
          if [ -t 1 ] && [ -z "''${NO_COLOR:-}" ]; then
            bold=$'\e[1m' name=$'\e[1;36m' dim=$'\e[2m' reset=$'\e[0m'
          else
            bold= name= dim= reset=
          fi

          heading() { printf '\n%s%s%s\n' "$bold" "$1" "$reset"; }
          row() { printf '  %s%-${toString width}s%s  %s%s%s\n' "$name" "$1" "$reset" "$dim" "$2" "$reset"; }

          heading Commands
          ${rows config.my.commands}
          heading Aliases
          ${rows aliases}
          printf '\n%s<command> --help for details where supported%s\n' "$dim" "$reset"
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
      config.environment.shellAliases = {
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
