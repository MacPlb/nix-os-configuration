{ pkgs, pkgs-unstable, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    models = "/var/lib/ollama/models";
    host = "127.0.0.1";
    port = 11434;
    openFirewall = false;
    loadModels = [
      "llama3.2:3b"
      "nomic-embed-text"
    ];
  };

  environment.systemPackages = [
    pkgs-unstable.codex
    pkgs-unstable.claude-code
  ];
}
