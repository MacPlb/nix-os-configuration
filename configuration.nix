{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/software/development.nix
    ./modules/software/common.nix
    ./modules/software/creative_software.nix
    ./modules/software/niri.nix
    ./modules/software/other.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nietzsche";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # Fonts
  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;

    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.fira-code
    ];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  # Gnome loagin manager
  services.displayManager.gdm.enable = true;

  console.keyMap = "pl2";

  services.printing.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.friedrich = {
    isNormalUser = true;
    description = "Friedrich";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Extra drive
  fileSystems."/mnt/sda1" = {
    device = "/dev/disk/by-uuid/D612174D121731CB";
    fsType = "ntfs";
    options = [
      "defaults"
      "nofail"
    ];
  };

  fileSystems."/mnt/nvme3" = {
    device = "/dev/disk/by-uuid/B8886DEF886DAD16";
    fsType = "ntfs";
    options = [ "defaults" "nofail" ];
  };

  #Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  nixpkgs.config.allowUnfree = true;


  programs.xwayland.enable = true;
  
  system.stateVersion = "24.11";
}
