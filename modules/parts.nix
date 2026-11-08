# Flake-wide outputs that aren't machines: formatter, dev shell and checks.
{ lib, self, ... }:

{
  systems = [ "x86_64-linux" ];

  # Adds the flake-parts options as `debug.options` for nixd completions (see
  # .zed/settings.json).
  debug = true;

  perSystem =
    { pkgs, system, ... }:
    {
      # `nix fmt` formats every .nix file in the repo.
      formatter = pkgs.nixfmt-tree;

      # `nix develop`: tools for working on this repo, then `make help`.
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          gnumake
          git
          rsync
          nixfmt-tree
          wf-recorder # screen recording for README showcases
          ffmpeg # converts recordings to GIF
        ];
        shellHook = "make --no-print-directory help";
      };

      # `nix flake check` builds every host, checks formatting and rejects hex colors
      # outside colors.nix.
      checks =
        lib.mapAttrs (_: host: host.config.system.build.toplevel) (
          lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system) self.nixosConfigurations
        )
        // {
          formatting = pkgs.runCommand "check-formatting" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
            find ${self} -name '*.nix' -exec nixfmt --check {} +
            touch $out
          '';

          # colors.nix is the only place hex colors are allowed.
          single-color-source = pkgs.runCommand "check-single-color-source" { } ''
            cd ${self}
            if grep -rnIE '#[0-9a-fA-F]{6}([0-9a-fA-F]{2})?\b' dotfiles modules \
                --exclude=colors.nix; then
              echo "Hex colors above belong in modules/theme/colors.nix." >&2
              exit 1
            fi
            touch $out
          '';
        };
    };
}
