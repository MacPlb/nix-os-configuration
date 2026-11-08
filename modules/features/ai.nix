# Local LLMs (Ollama on Vulkan, localhost only) and coding agents.
{
  flake.nixosModules.ai =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.unstable.opencode
      ];
    };
}
