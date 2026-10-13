# Host-specific settings for nietzsche (Ryzen 5 7500F, RX 7700 XT, MT7921 wifi).
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/nix.nix
    ../../modules/system/locale.nix
    ../../modules/system/desktop.nix
    ../../modules/system/services.nix
    ../../modules/software/ai.nix
    ../../modules/software/development.nix
    ../../modules/software/common.nix
    ../../modules/software/creative_software.nix
    ../../modules/software/gdm-wallpaper.nix
    ../../modules/software/niri.nix
    ../../modules/software/other.nix
  ];

  networking.hostName = "nietzsche";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  boot.tmp.cleanOnBoot = true;

  # Newer kernels and early amdgpu loading help RDNA3 cards like the RX 7700 XT.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # MT7921 (mt7921e) wifi: PCIe ASPM causes latency spikes and throughput drops.
  boot.extraModprobeConfig = "options mt7921e disable_aspm=1";
  # Wifi power saving adds latency and cuts throughput on mt7921e.
  networking.networkmanager.wifi.powersave = false;

  # Desktop: let amd-pstate-epp boost eagerly instead of balancing for power.
  powerManagement.cpuFreqGovernor = "performance";

  # sched_ext scheduler tuned for interactivity; keeps the desktop smooth under full CPU load.
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  hardware.enableRedistributableFirmware = true;

  # Mesa (RADV Vulkan, radeonsi VA-API) is the default driver set.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  zramSwap.enable = true;

  users.users.friedrich = {
    isNormalUser = true;
    description = "Friedrich";
    extraGroups = [
      "input"
      "lp"
      "networkmanager"
      "scanner"
      "video"
      "wheel"
    ];
  };

  # Release this machine was installed with; never bump it on upgrades.
  system.stateVersion = "25.11";
}
