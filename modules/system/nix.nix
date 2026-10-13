{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = false;
      warn-dirty = false;
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
}
