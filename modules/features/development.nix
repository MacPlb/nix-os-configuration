# Docker, Git, IDEs and language toolchains. .NET is in dotnet.nix.
{
  flake.nixosModules.development =
    { config, pkgs, ... }:
    {
      virtualisation.docker.enable = true;
      users.users.${config.my.user}.extraGroups = [ "docker" ];

      programs.git = {
        enable = true;
        config = {
          user = {
            name = "MacPlb";
            email = "macplb@proton.me";
          };
          core = {
            sshCommand = "ssh -i ~/.ssh/macplb";
          };
        };
      };

      environment.shellAliases.zj = "zellij";

      environment.systemPackages = with pkgs; [
        # Utils
        bat
        ripgrep

        # IDE
        unstable.jetbrains.pycharm
        unstable.jetbrains.rust-rover
        unstable.jetbrains.rider
        zellij
        vscode
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

        # Nix language servers and formatter (editor setup: .zed/settings.json, README)
        nixd
        nil
        nixfmt
      ];
    };
}
