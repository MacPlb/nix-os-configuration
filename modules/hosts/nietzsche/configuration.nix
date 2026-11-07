# Desktop (main machine): Ryzen 5 7500F, RX 7700 XT, MT7921 wifi, Dell S2725QS + MSI MAG271C.
{ inputs, self, ... }:

{
  flake.nixosConfigurations.nietzsche = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hostNietzsche ];
  };

  flake.nixosModules.hostNietzsche = {
    imports = [
      ./_hardware-configuration.nix
      self.nixosModules.base
      self.nixosModules.desktop
      self.nixosModules.workstation
      self.nixosModules.neovim
      self.nixosModules.apps
      self.nixosModules.development
      self.nixosModules.dotnet
      self.nixosModules.creative
      self.nixosModules.latex
      self.nixosModules.ai
    ];

    networking.hostName = "nietzsche";
    my.user = "friedrich";
    users.users.friedrich.description = "Friedrich";

    # Early amdgpu loading helps RDNA3 cards like the RX 7700 XT.
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    # MT7921 (mt7921e) wifi: PCIe ASPM causes latency spikes and throughput drops.
    boot.extraModprobeConfig = "options mt7921e disable_aspm=1";
    # Wifi power saving adds latency and cuts throughput on mt7921e.
    networking.networkmanager.wifi.powersave = false;

    # Pin the login panel to the main screen instead of mirroring it.
    services.displayManager.noctalia-greeter.settings.output.name = "HDMI-A-1";

    # Release this machine was installed with; never bump it on upgrades.
    system.stateVersion = "25.11";
  };
}
