# Desktop on mains power; favors performance over saving power.
{
  flake.nixosModules.workstation = {
    # Boost eagerly instead of balancing for power.
    powerManagement.cpuFreqGovernor = "performance";

    # Interactivity-focused sched_ext scheduler.
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    hardware.bluetooth.powerOnBoot = true;
  };
}
