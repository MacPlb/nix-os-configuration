# Networking, remote access, printing/scanning and disk/firmware maintenance.
{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;

      hardware.bluetooth.enable = true;

      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PermitRootLogin = "no";
          AllowTcpForwarding = "yes";
          GatewayPorts = "no";
        };
      };

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        # Announce <hostname>.local so `ssh fiodor@dostoyevsky.local` works across the LAN.
        publish = {
          enable = true;
          addresses = true;
        };
      };

      services.printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          hplip
        ];
      };
      # simple-scan needs SANE; this also creates the "scanner" group.
      hardware.sane = {
        enable = true;
        extraBackends = [
          pkgs.sane-airscan
          pkgs.hplip
        ];
      };

      services.fstrim.enable = true;
      services.fwupd.enable = true;
    };
}
