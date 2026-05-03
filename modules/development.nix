{ config, pkgs, ... }:

{ 
  # Git Setup
  programs.git = {
    enable = true;
    config.user = {
        name  = "PyDotDog";
        email = "palubickimaciej5@gmail.com";
    };
  };


  environment.systemPackages = with pkgs; [
    # Utils
    bat
    ripgrep

    # IDE
    jetbrains.rider
    jetbrains.pycharm
    neovim
    vscode 

    # Languages
    python315
    go
    rustup
   
  ];
}
