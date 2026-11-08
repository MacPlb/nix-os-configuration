# Links dotfiles from dotfiles/common and dotfiles/<hostname> into $HOME.
#
# Paths mirror the home directory, and host files override common ones. Each file is copied
# into the Nix store and linked with systemd-tmpfiles at boot and on every switch. Files are
# linked individually so apps can keep their own state next to them.
{
  flake.nixosModules.base =
    { config, lib, ... }:
    let
      cfg = config.dotfiles;
      user = config.users.users.${config.my.user};

      # { ".config/kitty/kitty.conf" = /…/dotfiles/common/.config/kitty/kitty.conf; … }
      filesIn =
        dir:
        lib.optionalAttrs (builtins.pathExists dir) (
          lib.listToAttrs (
            map (file: lib.nameValuePair (lib.removePrefix "${toString dir}/" (toString file)) file) (
              lib.filesystem.listFilesRecursive dir
            )
          )
        );

      # Copy each file into the store separately so editing one doesn't relink the others.
      # Store names can't start with a dot, hence the prefix.
      toStore =
        rel: source:
        if lib.isPath source then
          builtins.path {
            path = source;
            name = "dotfile" + builtins.replaceStrings [ "/" ] [ "-" ] "/${rel}";
          }
        else
          toString source;

      # ".config/kitty/kitty.conf" -> [ ".config" ".config/kitty" ]
      parentDirs =
        rel:
        let
          parts = lib.init (lib.splitString "/" rel);
        in
        lib.genList (i: lib.concatStringsSep "/" (lib.take (i + 1) parts)) (lib.length parts);

      links = lib.mapAttrs' (
        rel: source: lib.nameValuePair "${user.home}/${rel}" { "L+".argument = toStore rel source; }
      ) cfg.files;

      dirs = lib.listToAttrs (
        map (
          rel:
          lib.nameValuePair "${user.home}/${rel}" {
            d = {
              inherit (user) group;
              user = user.name;
            };
          }
        ) (lib.unique (lib.concatMap parentDirs (lib.attrNames cfg.files)))
      );

      # Targets must stay inside the home directory.
      badTargets = lib.filter (rel: lib.hasPrefix "/" rel || lib.elem ".." (lib.splitString "/" rel)) (
        lib.attrNames cfg.files
      );
    in
    {
      options.dotfiles = {
        sources = lib.mkOption {
          type = with lib.types; listOf path;
          description = "Directories laid out like the home directory; later ones override earlier ones.";
        };

        files = lib.mkOption {
          type = with lib.types; attrsOf path;
          default = { };
          description = ''
            Paths relative to the home directory and what to link there. Filled from `sources`;
            modules can add entries (e.g. a generated file or a store path from a package) or
            override them.
          '';
        };
      };

      config = {
        dotfiles.sources = [
          ../../dotfiles/common
          ../../dotfiles/${config.networking.hostName}
        ];

        dotfiles.files = lib.mapAttrs (_: lib.mkDefault) (
          lib.foldl' (files: dir: files // filesIn dir) { } cfg.sources
        );

        assertions = [
          {
            assertion = badTargets == [ ];
            message = "dotfiles.files targets must be relative paths inside the home directory: ${toString badTargets}";
          }
        ];

        systemd.tmpfiles.settings."10-dotfiles" = dirs // links;
      };
    };
}
