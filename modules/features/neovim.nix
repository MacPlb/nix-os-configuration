# Neovim running LazyVim, with every plugin, grammar, language server, formatter and debugger from
# Nix. lazy.nvim loads the plugins from one folder in the store (NVIM_LAZY_PLUGINS) and never
# downloads anything; Mason is off. The config is dotfiles/common/.config/nvim (keys: cheatsheet.md
# there, <F1> in nvim) and its colors come from the generated lua/theme.lua (modules/theme/apply.nix).
{
  flake.nixosModules.neovim =
    { lib, pkgs, ... }:
    let
      vp = pkgs.vimPlugins;

      # Compiled grammars and their queries in one folder (parser/, queries/), nvim-treesitter's
      # install_dir (NVIM_TS_PARSERS): LazyVim sees them as installed and builds nothing.
      grammars = pkgs.symlinkJoin {
        name = "nvim-treesitter-grammars";
        paths =
          (vp.nvim-treesitter.withPlugins (p: [
            p.bash
            p.c
            p.c_sharp
            p.cpp
            p.css
            p.diff
            p.dockerfile
            p.git_config
            p.git_rebase
            p.gitattributes
            p.gitignore
            p.gitcommit
            p.go
            p.gomod
            p.gosum
            p.html
            p.javascript
            p.jsdoc
            p.json
            p.json5
            p.lua
            p.luadoc
            p.luap
            p.make
            p.markdown
            p.markdown_inline
            p.ninja
            p.nix
            p.printf
            p.python
            p.query
            p.razor
            p.regex
            p.ron
            p.rst
            p.rust
            p.sql
            p.toml
            p.tsx
            p.typescript
            p.vim
            p.vimdoc
            p.xml
            p.yaml
          ])).dependencies;
      };

      # neotest-dotnet expects the pre-0.11 iter_matches(), where a capture is one node; it's a
      # list of nodes now. Without this no test is found ("attempt to call method 'start'").
      neotest-dotnet = vp.neotest-dotnet.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace lua/neotest-dotnet/framework-discovery.lua \
            --replace-fail "captures[1], source" \
                           "(type(captures[1]) == 'table' and captures[1][1] or captures[1]), source"
          for f in lua/neotest-dotnet/nunit/init.lua lua/neotest-dotnet/mstest/init.lua; do
            substituteInPlace $f --replace-fail "local args_node = match[arguments_index]" \
              "local args_node = match[arguments_index]
              if type(args_node) == 'table' then args_node = args_node[#args_node] end"
          done
        '';
      });

      # roslyn.nvim looks for this name (as the dotnet global tool installs it); nixpkgs' roslyn-ls
      # names its binary Microsoft.CodeAnalysis.LanguageServer.
      roslyn-language-server = pkgs.writeShellScriptBin "roslyn-language-server" ''
        exec ${lib.getExe' pkgs.roslyn-ls "Microsoft.CodeAnalysis.LanguageServer"} "$@"
      '';

      # debugpy for nvim-dap-python; the project's own venv still runs the code.
      debugpy = pkgs.python3.withPackages (p: [ p.debugpy ]);

      # Named like the repos in LazyVim's specs ("folke/snacks.nvim" -> snacks.nvim): lazy.nvim's
      # dev.path. A plugin a spec needs but this lacks shows up as "not installed" in :Lazy.
      lazyPlugins = pkgs.linkFarm "lazy-plugins" {
        "lazy.nvim" = vp.lazy-nvim;
        "LazyVim" = vp.LazyVim;

        # LazyVim core
        "blink.cmp" = vp.blink-cmp;
        "conform.nvim" = vp.conform-nvim;
        "flash.nvim" = vp.flash-nvim;
        "friendly-snippets" = vp.friendly-snippets;
        "gitsigns.nvim" = vp.gitsigns-nvim;
        "grug-far.nvim" = vp.grug-far-nvim;
        "lazydev.nvim" = vp.lazydev-nvim;
        "lualine.nvim" = vp.lualine-nvim;
        "mini.ai" = vp.mini-ai;
        "mini.icons" = vp.mini-icons;
        "mini.pairs" = vp.mini-pairs;
        "noice.nvim" = vp.noice-nvim;
        "nui.nvim" = vp.nui-nvim;
        "nvim-lint" = vp.nvim-lint;
        "nvim-lspconfig" = vp.nvim-lspconfig;
        "nvim-treesitter" = vp.nvim-treesitter;
        "nvim-treesitter-textobjects" = vp.nvim-treesitter-textobjects;
        "nvim-ts-autotag" = vp.nvim-ts-autotag;
        "persistence.nvim" = vp.persistence-nvim;
        "plenary.nvim" = vp.plenary-nvim;
        "snacks.nvim" = vp.snacks-nvim;
        "todo-comments.nvim" = vp.todo-comments-nvim;
        "trouble.nvim" = vp.trouble-nvim;
        "ts-comments.nvim" = vp.ts-comments-nvim;
        "which-key.nvim" = vp.which-key-nvim;

        # Extras: debugging and tests
        "nvim-dap" = vp.nvim-dap;
        "nvim-dap-ui" = vp.nvim-dap-ui;
        "nvim-dap-virtual-text" = vp.nvim-dap-virtual-text;
        "nvim-nio" = vp.nvim-nio;
        "neotest" = vp.neotest;

        # Extras: languages
        "roslyn.nvim" = vp.roslyn-nvim;
        "neotest-dotnet" = neotest-dotnet; # patched above
        "nvim-dap-go" = vp.nvim-dap-go;
        "neotest-golang" = vp.neotest-golang;
        "nvim-dap-python" = vp.nvim-dap-python;
        "neotest-python" = vp.neotest-python;
        "venv-selector.nvim" = vp.venv-selector-nvim;
        "rustaceanvim" = vp.rustaceanvim;
        "crates.nvim" = vp.crates-nvim;
        "clangd_extensions.nvim" = vp.clangd_extensions-nvim;
        "SchemaStore.nvim" = vp.SchemaStore-nvim;
        "markdown-preview.nvim" = vp.markdown-preview-nvim;
        "render-markdown.nvim" = vp.render-markdown-nvim;
        "vim-dadbod" = vp.vim-dadbod;
        "vim-dadbod-completion" = vp.vim-dadbod-completion;
        "vim-dadbod-ui" = vp.vim-dadbod-ui;

        # Extras: editing and UI
        "mini.base16" = vp.mini-base16; # our colors
        "harpoon" = vp.harpoon2;
        "mini.surround" = vp.mini-surround;
        "mini.hipatterns" = vp.mini-hipatterns;
        "yanky.nvim" = vp.yanky-nvim;
        "inc-rename.nvim" = vp.inc-rename-nvim;
        "dial.nvim" = vp.dial-nvim;
        "nvim-treesitter-context" = vp.nvim-treesitter-context;
      };

      neovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
        viAlias = true;
        vimAlias = true;
        # lazy.nvim loads the plugins; nvim reads ~/.config/nvim/init.lua as usual.
        wrapRc = false;
        withPython3 = false;
        withNodeJs = false;
        withRuby = false;
        plugins = [ ];
        wrapperArgs = [
          "--suffix"
          "PATH"
          ":"
          (lib.makeBinPath (
            with pkgs;
            [
              wl-clipboard
              ripgrep
              fd
              jq
              trash-cli # the file explorer deletes to the trash
              lazygit # <Space>gg
              inotify-tools # fast file watching for the language servers (else nvim polls)

              # Language servers
              roslyn-language-server # C#, via roslyn.nvim
              gopls
              pyright
              ruff
              vtsls # TypeScript / JavaScript
              vscode-langservers-extracted # JSON, HTML, CSS
              marksman # Markdown
              yaml-language-server
              taplo # TOML
              bash-language-server
              dockerfile-language-server
              docker-compose-language-service
              nixd
              lua-language-server
              rust-analyzer
              clang-tools

              # Formatters
              nixfmt
              csharpier
              gotools # goimports
              gofumpt
              prettier
              stylua
              shfmt
              markdown-toc

              # Linters (nvim-lint)
              markdownlint-cli2
              golangci-lint
              hadolint
              shellcheck
              sqlfluff
              statix

              # Go code actions (gomodifytags, impl)
              gomodifytags
              impl

              # Debuggers
              netcoredbg
              delve
            ]
          ))
          "--set"
          "NVIM_LAZY_PLUGINS"
          "${lazyPlugins}"
          "--set"
          "NVIM_TS_PARSERS"
          "${grammars}"
          "--set"
          "NVIM_DEBUGPY_PYTHON"
          (lib.getExe debugpy)
        ];
      };
    in
    {
      environment.systemPackages = [ neovim ];

      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
}
