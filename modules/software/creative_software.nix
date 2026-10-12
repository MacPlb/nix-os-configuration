{ pkgs, ... }:

{


  environment.systemPackages = with pkgs; [
    # Photimage
    gimp
    pinta

    #VideoEditing
    shotcut

    #recording
    obs-studio

    #Video
    mpv
  ];
}
