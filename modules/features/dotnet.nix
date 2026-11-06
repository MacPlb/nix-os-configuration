# .NET development for Rider and Zed: one `dotnet` with several SDKs, language servers, debugger
# and the native libraries that NuGet tools and downloaded servers expect.
{
  flake.nixosModules.dotnet =
    { lib, pkgs, ... }:
    let
      d = pkgs.dotnetCorePackages;

      # Older SDKs to build and run projects that target them. nixpkgs marks an SDK insecure
      # once it's out of support (.NET 8 and 9: November 2026); it is then left out with a
      # warning instead of breaking the build. Remove it here once no project needs it.
      olderSdks = [
        d.sdk_9_0
        d.sdk_8_0
      ];
      supported = lib.filter (sdk: !(sdk.meta.insecure or false)) olderSdks;
      dropped = lib.subtractLists supported olderSdks;

      # The newest SDK first: it's the default when a project has no global.json.
      sdk = d.combinePackages ([ d.sdk_10_0 ] ++ supported);
      root = "${sdk}/share/dotnet";
    in
    {
      warnings = map (
        sdk: "dotnet: ${sdk.name} is out of support and was left out; projects targeting it won't run."
      ) dropped;

      environment.systemPackages = with pkgs; [
        sdk
        dotnet-ef # Entity Framework Core migrations
        csharpier # formatter (Rider plugin, Zed external formatter)
        netcoredbg # debug adapter for Zed (Rider uses its own debugger)
        # C# language servers; Zed's C# extension finds OmniSharp and csharp-ls on PATH
        omnisharp-roslyn
        csharp-ls
        roslyn-ls # Microsoft.CodeAnalysis.LanguageServer, for Zed's Roslyn server
        mono # .NET Framework / Mono projects
        roslyn # csc/vbc compilers for Mono
      ];

      environment.sessionVariables = {
        # Rider, the language servers and app hosts find the SDKs and runtimes here.
        DOTNET_ROOT = root;
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        DOTNET_NOLOGO = "1";
        # `dotnet tool install --global` puts tools here.
        PATH = [ "$HOME/.dotnet/tools" ];
      };

      # App hosts (global tools, published apps) started outside a login shell, e.g. by an IDE,
      # look up the runtime here when DOTNET_ROOT isn't set.
      environment.etc."dotnet/install_location".text = root;

      # Prebuilt native binaries from NuGet and IDE downloads (dotnet tools, Grpc.Tools' protoc,
      # Zed's downloaded language servers, SkiaSharp/Avalonia natives) run through nix-ld.
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          stdenv.cc.cc.lib
          zlib
          icu
          openssl
          krb5 # System.Net.Security (Negotiate/NTLM)
          lttng-ust
          curl
          # GUI frameworks (Avalonia, SkiaSharp) on X11/XWayland
          fontconfig
          freetype
          libGL
          libX11
          libICE
          libSM
          libXcursor
          libXext
          libXi
          libXrandr
        ];
      };

      # `dotnet watch`, hot reload and every IDE file watcher use an inotify instance each; the
      # default of 128 runs out quickly ("The configured user limit (128) on the number of
      # inotify instances has been reached").
      boot.kernel.sysctl = {
        "fs.inotify.max_user_instances" = 8192;
        "fs.inotify.max_user_watches" = 524288;
      };
    };
}
