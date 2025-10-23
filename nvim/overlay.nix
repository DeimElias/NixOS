final: prev: {
  rPackages = prev.rPackages // {
    nvimcom = final.rPackages.buildRPackage {
      name = "nvimcom";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "main";
        sha256 = "sha256-mb8HCaMasPUP9JZUkH1sPrtdbhM2HMUkJEKDsRt6wTs=";
      };
      sourceRoot = "source/nvimcom";
      buildInputs = with final; [
        R
        gcc
        gnumake
      ];
    };
  };
  rEnv = prev.radianWrapper.override {
    wrapR = true;
    recommendedPackages =
      prev.radianWrapper.recommendedPackages ++ (with final.rPackages; [ tidyverse ]);
  };
  vimPlugins = prev.vimPlugins // {
    r-nvim = final.vimUtils.buildVimPlugin {
      pname = "R.nvim";
      version = "2025-08-20";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "main";
        sha256 = "sha256-mb8HCaMasPUP9JZUkH1sPrtdbhM2HMUkJEKDsRt6wTs=";
      };
      runtimeDeps = [
        final.rEnv
        final.rPackages.nvimcom
      ];
    };
    cmp-r = final.vimUtils.buildVimPlugin {
      pname = "cmp-r";
      version = "2025-08-05";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "cmp-r";
        rev = "main";
        sha256 = "sha256-TwmLSILu1H3RyRivCQlbsgUN4dsEqO1E8Hx71N/lFws=";
      };
      doCheck = false;
      passthru.runtimeDeps = [ final.quarto ];
      buildInputs = with final; [
        R
        quarto
      ];
    };
    nvim-lspconfig = prev.vimPlugins.nvim-lspconfig.overrideAttrs (
      original:
      original
      // {
        passthru.runtimeDeps = with final; [
          # All language dependencies
          nixd
          nixfmt-rfc-style
          lua-language-server
          ruff
          sqruff
          pyright
          jinja-lsp
          ccls
          tailwindcss-language-server
          vscode-langservers-extracted

          # runtimeDeps
          ripgrep
          sqlcmd
          sqlite
        ];
      }
    );

  };

  neovim = final.wrapNeovimUnstable final.neovim-unwrapped {
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
      cmp-r
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
      (tokyonight-nvim.overrideAttrs (original: {
        doCheck = false;
      }))
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
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
      	  substituteInPlace $out/lua/plugins/lspconfig.lua --replace FIXME ${final.vimUtils.packDir final.neovim.passthru.packpathDirs}
    '';
  };
}
