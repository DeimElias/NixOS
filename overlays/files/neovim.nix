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
    recommendedPackages = prev.radianWrapper.recommendedPackages ++ (with final.rPackages; [ nvimcom ]);
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
      runtimeDeps = [ final.rEnv ];
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
          pyright

          # runtimeDeps
          ripgrep
          sqlcmd
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
      (tokyonight-nvim.overrideAttrs (original: {
        doCheck = false;
      }))
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
    ];
    luaRcContent = (
      prev.lib.concatLines (
        map (file: import file { inherit final; }) [
          ../specs/lua.nix
          ../specs/r-nvim.nix
          ../specs/blink.nix
          ../specs/tree.nix
        ]
      )
    );
  };
}
