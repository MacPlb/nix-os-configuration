# Laptop: Dell Latitude 5531, i7-12800H (Alder Lake, Iris Xe), NVIDIA GeForce MX550,
# 32 GB RAM, 2 × 512 GB NVMe.
{ inputs, self, ... }:

{
  flake.nixosConfigurations.dostoyevsky = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hostDostoyevsky ];
  };

  flake.nixosModules.hostDostoyevsky =
    { config, pkgs, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        self.nixosModules.base
        self.nixosModules.desktop
        self.nixosModules.laptop
        self.nixosModules.neovim
        self.nixosModules.apps
        self.nixosModules.development
        self.nixosModules.dotnet
        self.nixosModules.creative
        self.nixosModules.ai
      ];

      networking.hostName = "dostoyevsky";
      my.user = "fiodor";
      users.users.fiodor.description = "Fiodor";

      # The NVIDIA driver is built for one kernel; the LTS kernel avoids breakage when
      # linuxPackages_latest moves ahead of the driver.
      boot.kernelPackages = pkgs.linuxPackages;

      # Boot screens at the panel's native 1920x1080: systemd-boot picks the highest
      # firmware mode, and early i915 loading switches the console to native resolution
      # right away instead of the low-res EFI framebuffer.
      boot.loader.systemd-boot.consoleMode = "max";
      boot.initrd.kernelModules = [ "i915" ];

      # Iris Xe: VA-API (iHD) and oneVPL video decoding/encoding.
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
      environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

      # PRIME offload: the Intel GPU drives the screen, the MX550 powers up only for apps
      # started with `nvidia-offload <command>`.
      services.xserver.videoDrivers = [
        "modesetting"
        "nvidia"
      ];
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        # The MX550 is Turing, which the open kernel module supports.
        open = true;
        modesetting.enable = true;
        # Save VRAM across suspend and power the GPU off when idle (RTD3).
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          # Check with `lspci -D | grep -Ei 'vga|3d'` and convert hex to decimal:
          # 0000:00:02.0 -> PCI:0:2:0, 0000:01:00.0 -> PCI:1:0:0.
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      # Intel thermal daemon; keeps the i7-12800H out of thermal throttling.
      services.thermald.enable = true;

      # Fingerprint reader: Broadcom ControlVault 3 (0a5c:5843), needs Dell's proprietary
      # TOD driver. Enroll with `fprintd-enroll`; PAM then accepts a finger for login/sudo.
      services.fprintd = {
        enable = true;
        tod = {
          enable = true;
          driver = pkgs.libfprint-2-tod1-broadcom;
        };
      };

      # Release this machine was installed with; never bump it on upgrades.
      system.stateVersion = "26.05";
    };
}
