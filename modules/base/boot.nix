# Bootloader, kernel, firmware and graphics stack shared by all hosts (UEFI only).
{
  flake.nixosModules.base =
    { lib, pkgs, ... }:
    {
      boot.loader.systemd-boot = {
        enable = true;
        # Keeps the EFI partition from filling up with old kernels; older generations are
        # still in the store until `nh clean` removes them.
        configurationLimit = 20;
      };
      boot.loader.efi.canTouchEfiVariables = true;
      # Hold Space during boot to open the menu for an older generation.
      boot.loader.timeout = 0;
      boot.tmp.cleanOnBoot = true;

      # Silent boot: no kernel/udev log or systemd "[  OK  ]" status lines on the console.
      # Failures still print; `journalctl -b` has the full log.
      boot.consoleLogLevel = 3;
      boot.initrd.verbose = false;
      boot.kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
        "rd.systemd.show_status=auto"
      ];

      # Newest kernel for recent GPUs; hosts with out-of-tree drivers (NVIDIA) override it.
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      hardware.enableRedistributableFirmware = true;

      # Mesa (RADV/ANV Vulkan, VA-API) is the default driver set.
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      zramSwap.enable = true;
    };
}
