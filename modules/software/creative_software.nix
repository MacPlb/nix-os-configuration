{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Images
    gimp
    pinta

    # Video editing and recording
    shotcut
    obs-studio

    # Playback
    mpv

    # Non-free codecs (H.264/H.265/AAC…) for GStreamer apps and the ffmpeg CLI
    ffmpeg-full
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];
}
