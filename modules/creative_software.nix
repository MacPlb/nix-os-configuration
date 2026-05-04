{ config, pkgs, ... }:

{ 


  environment.systemPackages = with pkgs; [
    # Photimage
    gimp

    #VideoEditing
    shotcut

    #recording
    obs-studio
  ];
}
