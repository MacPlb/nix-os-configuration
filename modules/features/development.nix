# Docker, Git, IDEs and language toolchains. .NET is in dotnet.nix.
{
  flake.nixosModules.development =
    { config, pkgs, ... }:
    {
      virtualisation.docker = {
        enable = true;
        # Clean up old containers, images, build cache and networks weekly. Volumes are left
        # alone.
        autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [
            "--filter"
            "until=168h"
          ];
        };
        # Cap container logs so they can't fill the disk.
        daemon.settings = {
          log-driver = "json-file";
          log-opts = {
            max-size = "10m";
            max-file = "3";
          };
        };
      };
      users.users.${config.my.user}.extraGroups = [ "docker" ];

      programs.git = {
        enable = true;
        config = {
          user = {
            name = "MacPlb";
            email = "macplb@proton.me";
          };
          core = {
            # Syntax-highlighted diffs.
            pager = "delta";
          };
          interactive.diffFilter = "delta --color-only";
          delta = {
            navigate = true; # n/N jump between files
            line-numbers = true;
          };
          merge.conflictStyle = "zdiff3";
          init.defaultBranch = "main";
          pull.rebase = true;
          rebase.autoStash = true;
          push.autoSetupRemote = true;
          fetch.prune = true;
          # Reuse recorded conflict resolutions.
          rerere.enabled = true;
          diff.colorMoved = "default";
        };
      };

      # GitHub key: macplb on one machine, id_ed25519 on the other. Missing IdentityFile
      # entries are skipped.
      programs.ssh.extraConfig = ''
        Host github.com
          IdentityFile ~/.ssh/macplb
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes
      '';

      environment.shellAliases.zj = "zellij";

      environment.systemPackages = with pkgs; [
        # Utils
        bat
        ripgrep
        delta # git pager (programs.git above)

        # IDE
        unstable.jetbrains.pycharm
        unstable.jetbrains.rust-rover
        unstable.jetbrains.rider
        zellij
        # Stable 1.144.0 fails in patchPhase (bundled ripgrep moved); unstable has the fix.
        unstable.vscode
        zed-editor

        # Containers, infrastructure, APIs and databases
        docker-compose
        terraform
        bruno
        dbeaver-bin
        drawio

        # Languages
        python3
        go
        # Nix toolchain instead of rustup: RustRover reads it from /run/current-system/sw/bin
        (unstable.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" ];
        })
        gcc
        nodejs

        # Faster Rust builds; configured in dotfiles/common/.cargo/config.toml.
        mold
        sccache
        cargo-nextest # faster test runner: `cargo nextest run`
        cargo-watch # rerun on save: `cargo watch -x check`

        # Language servers and debuggers for Zed/VS Code outside the JetBrains IDEs
        gopls
        delve
        pyright
        ruff
        typescript-language-server
        typescript

        # Nix language servers and formatter (editor setup: .zed/settings.json, README)
        nixd
        nil
        nixfmt
      ];
    };
}
