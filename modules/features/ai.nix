{
  flake.nixosModules.ai =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.unstable.opencode
        pkgs.unstable.claude-code
      ];
    };
}
