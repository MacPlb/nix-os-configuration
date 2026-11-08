# Laptop power reporting and profiles, plus lid handling.
{
  flake.nixosModules.laptop = {
    # Battery level and charging state for Noctalia's battery widget.
    services.upower.enable = true;
    # Balanced/power-saver/performance switching from Noctalia's power profile widget.
    services.power-profiles-daemon.enable = true;

    # Bluetooth starts off.
    hardware.bluetooth.powerOnBoot = false;

    # Docker starts on the first `docker` command (socket activation).
    virtualisation.docker.enableOnBoot = false;

    # Suspend on lid close, but not while docked with the lid shut.
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
