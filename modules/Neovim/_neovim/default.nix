final: prev: {
  rPackages = prev.rPackages // {
    nvimcom = final.rPackages.buildRPackage {
      name = "nvimcom";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "v1.0.0";
        sha256 = "sha256-FywUL3mV2+kfu+rO6uUFyUv80EflbdgSkYuSnW965UE=";
      };
      sourceRoot = "source/nvimcom";
      buildInputs = with final; [
        R
        gcc
        gnumake
      ];
    };
  };
  r_ls = final.stdenv.mkDerivation {
    name = "r_ls";
    src = final.fetchFromGitHub {
      owner = "R-nvim";
      repo = "R.nvim";
      rev = "v1.0.0";
      sha256 = "sha256-FywUL3mV2+kfu+rO6uUFyUv80EflbdgSkYuSnW965UE=";
    };
    sourceRoot = "source/rnvimserver";
    installPhase = ''
            install -D rnvimserver $out/bin/rnvimserver
      	'';
  };

  rEnv = prev.radianWrapper.override {
    wrapR = true;
    recommendedPackages =
      prev.radianWrapper.recommendedPackages
      ++ (with final.rPackages; [
        knitr
        rmarkdown
        styler
        tidyverse
        nvimcom
      ]);
  };
  vimPlugins = prev.vimPlugins // {
    r-nvim = final.vimUtils.buildVimPlugin {
      pname = "R.nvim";
      version = "2025-08-20";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "v1.0.0";
        sha256 = "sha256-FywUL3mV2+kfu+rO6uUFyUv80EflbdgSkYuSnW965UE=";
      };
      patches = [ ./patches/remove-rnvimserver-compilation.patch ];
      runtimeDeps = [
        final.rEnv
        final.r_ls
      ];
    };
    nvim-lspconfig = prev.vimPlugins.nvim-lspconfig.overrideAttrs (
      original:
      original
      // {
        passthru.runtimeDeps =
          with final;
          [
            # Language server
            nixd
            nixfmt
            lua-language-server
            ruff
            sqruff
            pyright
            jinja-lsp
            ccls
            harper
            tailwindcss-language-server
            vscode-langservers-extracted
            typescript-language-server
            eslint
            gnumake
            gcc
            tinymist

            # Debug adapters
            gdb

            # runtimeDeps
            websocat
            ripgrep
            sqlcmd
            sqlite
            typst
          ]
          ++ final.lib.optionals (original.passthru ? runtimeDeps) original.passthru.runtimeDeps;
      }
    );

  };

  myNeovim = final.wrapNeovimUnstable final.neovim-unwrapped {
    vimAlias = true;
    viAlias = true;
    plugins = with final.vimPlugins; [
      lazy-nvim
      plenary-nvim
      flash-nvim
      r-nvim
      which-key-nvim
      blink-cmp
      blink-compat
      otter-nvim
      telescope-nvim
      typst-preview-nvim
      # (typst-preview-nvim.overrideAttrs {
      #   patches = [
      #     (final.fetchpatch {
      #       url = "https://github.com/Daniel-42-z/typst-preview.nvim/commit/f3d1cf863f9d626629fc80b5dd85195117dcf338.patch";
      #       hash = "sha256-IzwFwH05jis2tOaoIIF+g4wecw11lG+6cEZlOE3PqQQ=";
      #     })
      #   ];
      # })
      undotree
      vim-dadbod
      vim-dadbod-ui
      vim-dadbod-completion
      neogit
      gitsigns-nvim
      lualine-nvim
      nvim-web-devicons
      noice-nvim
      nui-nvim
      nvim-notify
      diffview-nvim
      harpoon2
      (tokyonight-nvim.overrideAttrs (original: {
        doCheck = false;
      }))
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-dap
      nvim-dap-ui
      render-markdown-nvim
    ];
    luaRcContent = (import ./lua.nix { inherit final; });
  };
  neovim-conf = final.stdenv.mkDerivation {
    pname = "neovim-conf";
    version = "1.0";
    src = ./lua;
    installPhase = ''
      	mkdir -p $out/lua
              cp -r ./* $out/lua
      	'';
    fixupPhase = ''
          substituteInPlace $out/lua/plugins/tinymist-preview.lua --replace TINYMIST ${final.tinymist}/bin/tinymist
          substituteInPlace $out/lua/plugins/tinymist-preview.lua --replace WEBSOCAT ${final.websocat}/bin/websocat
      	  substituteInPlace $out/lua/plugins/lspconfig.lua --replace FIXME ${final.vimUtils.packDir final.myNeovim.passthru.packpathDirs}
    '';
  };
}
