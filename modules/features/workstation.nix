# Desktop PC on mains power: performance over power saving.
{
  flake.nixosModules.workstation = {
    # Let amd-pstate-epp/intel_pstate boost eagerly instead of balancing for power.
    powerManagement.cpuFreqGovernor = "performance";

    # sched_ext scheduler tuned for interactivity; keeps the desktop smooth under full CPU load.
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    hardware.bluetooth.powerOnBoot = true;
  };
}
