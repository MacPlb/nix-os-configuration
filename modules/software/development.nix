{ pkgs, pkgs-unstable, ... }:

{
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
    pkgs-unstable.jetbrains.rider
    pkgs-unstable.zed-editor
    pkgs-unstable.neovim
    antigravity
    vscode

    # Languages
    python3
    go
    rustup
    gcc

    # NIX
    nil
    nixd
  ];
}
