# The machine's only interactive user; hosts set the name, dotfiles are linked into their home.
{
  flake.nixosModules.base =
    { config, lib, ... }:
    {
      options.my.user = lib.mkOption {
        type = lib.types.strMatching "[a-z_][a-z0-9_-]*";
        example = "friedrich";
        description = "Login name of the machine's only interactive user; dotfiles are linked into their home.";
      };

      config.users.users.${config.my.user} = {
        isNormalUser = true;
        extraGroups = [
          "input"
          "lp"
          "networkmanager"
          "scanner"
          "video"
          "wheel"
        ];
      };
    };
}
