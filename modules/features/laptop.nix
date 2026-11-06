# Laptop on battery: power reporting and profiles for Noctalia's widgets, lid handling.
{
  flake.nixosModules.laptop = {
    # Battery level and charging state for Noctalia's battery widget.
    services.upower.enable = true;
    # Balanced/power-saver/performance switching from Noctalia's power profile widget.
    services.power-profiles-daemon.enable = true;

    # Bluetooth stays off until toggled, to save battery.
    hardware.bluetooth.powerOnBoot = false;

    # Suspend on lid close, but not while docked with the lid shut.
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
