# Flake-wide outputs that aren't machines: formatter, dev shell and checks.
{ lib, self, ... }:

{
  systems = [ "x86_64-linux" ];

  # Exposes the flake-parts options as `debug.options`, so nixd can complete `flake.*` and
  # `perSystem` in modules/ (see .zed/settings.json).
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

      # `nix flake check` builds every host (including the niri/noctalia config validation in
      # system.checks), fails on unformatted Nix files and on colors defined outside the theme.
      checks =
        lib.mapAttrs (_: host: host.config.system.build.toplevel) (
          lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system) self.nixosConfigurations
        )
        // {
          formatting = pkgs.runCommand "check-formatting" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
            find ${self} -name '*.nix' -exec nixfmt --check {} +
            touch $out
          '';

          # modules/theme/colors.nix is the only place colors are written down.
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
