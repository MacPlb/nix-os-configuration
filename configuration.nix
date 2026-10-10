{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/software/ai.nix
    ./modules/software/development.nix
    ./modules/software/common.nix
    ./modules/software/creative_software.nix
    ./modules/software/niri.nix
    ./modules/software/other.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  # Newer kernels and early amdgpu loading help RDNA3 cards like the RX 7700 XT.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.enableRedistributableFirmware = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
    };

  };

  networking.hostName = "nietzsche";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

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
    videoDrivers = [ "amdgpu" ];
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";
  services.greetd.enable = false;

  system.activationScripts.hideRootFromGdm.text = ''
    accounts_dir=/var/lib/AccountsService/users
    root_account=$accounts_dir/root

    install -d -m 0755 "$accounts_dir"
    cat > "$root_account" <<'EOF'
[User]
SystemAccount=true
EOF
    chmod 0644 "$root_account"
  '';

  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          icon-theme = "Papirus-Dark";
          accent-color = "purple";
        };

        "org/gnome/login-screen" = {
          disable-user-list = false;
        };
      };
    }
  ];

  console.keyMap = "pl2";

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
    ];
  };
  services.fstrim.enable = true;
  services.fwupd.enable = true;
  services.dbus.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  zramSwap.enable = true;

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
      "input"
      "lp"
      "networkmanager"
      "scanner"
      "video"
      "wheel"
    ];
  };

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
    options = [
      "defaults"
      "nofail"
    ];
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = false;

  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;
  programs.xwayland.enable = true;

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  system.stateVersion = "25.11";
}
