{ ... }:

{
  xdg.desktopEntries.nuclear = {
    name = "Nuclear";
    exec = "nuclear --ozone-platform-hint=auto --enable-features=UseOzonePlatform";
    icon = "nuclear";
    terminal = false;
    type = "Application";
    categories = [ "AudioVideo" ];
  };
}
