# Nix daemon and store maintenance.
{
  flake.nixosModules.base = {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = false;
        warn-dirty = false;
        # Lets wheel users (you) use binary caches that a project's flake asks for.
        trusted-users = [ "@wheel" ]; # root is added by NixOS
        # Keep build inputs of anything kept alive, so `nix develop` shells and dev builds don't
        # have to re-download their toolchains after every garbage collection.
        keep-outputs = true;
        keep-derivations = true;
        extra-substituters = [ "https://nix-community.cachix.org" ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      # Builds run at idle priority so rebuilds don't stall the desktop.
      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";
      # Deduplicate off the rebuild path, with idle CPU and I/O priority.
      optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };
    };
  };
}
