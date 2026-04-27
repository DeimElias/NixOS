final: prev: {
  rPackages = prev.rPackages // {
    nvimcom = final.rPackages.buildRPackage {
      name = "nvimcom";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "c37d1cfd46fe0c5ab7e5384154adf985c537cbcc";
        sha256 = "sha256-Qz7fyY/juwA76gzXR8aNkb9fbB0wTWCaG/9qUJMzez0=";
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
      rev = "c37d1cfd46fe0c5ab7e5384154adf985c537cbcc";
      sha256 = "sha256-Qz7fyY/juwA76gzXR8aNkb9fbB0wTWCaG/9qUJMzez0=";
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
        rev = "c37d1cfd46fe0c5ab7e5384154adf985c537cbcc";
        sha256 = "sha256-Qz7fyY/juwA76gzXR8aNkb9fbB0wTWCaG/9qUJMzez0=";
      };
      patches = [ ./patches/remove-rnvimserver-compilation.patch ];
      # patchPhase = ''
      #   substituteInPlace r/lsp/init.lua \
      #   --replace-fail "cmake_minimum_required ( VERSION 3.0 )" "cmake_minimum_required ( VERSION 3.10 )"
      # '';
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

            # Debug adapters
            gdb

            # runtimeDeps
            ripgrep
            sqlcmd
            sqlite
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
      	  substituteInPlace $out/lua/plugins/lspconfig.lua --replace FIXME ${final.vimUtils.packDir final.myNeovim.passthru.packpathDirs}
    '';
  };
}
