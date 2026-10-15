{ pkgs, pkgs-unstable, ... }:

{
  virtualisation.docker.enable = true;
  users.users.friedrich.extraGroups = [ "docker" ];

  # Git Setup
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "PyDotDog";
        email = "palubickimaciej5@gmail.com";
      };
      core = {
        sshCommand = "ssh -i ~/.ssh/id_ed25519";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # Utils
    bat
    ripgrep

    # IDE
    pkgs-unstable.jetbrains.pycharm
    pkgs-unstable.jetbrains.rust-rover
    pkgs-unstable.jetbrains.rider
    tmux
    vscode

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
    (pkgs-unstable.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" ];
    })
    gcc
    nodejs

    # NIX
    nil
    nixd
  ];
}
