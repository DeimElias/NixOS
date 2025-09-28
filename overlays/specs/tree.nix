{ ... }:
# lua
''
      {
      	"nvim-treesitter/nvim-treesitter",
      		opts = {
      			auto_install = false,
      			ensure_installed = {},
      			highlight = {enalble = true, additional_vim_regex_highlighting = false,},
      		}
      },
      }
      }
      )
      vim.api.nvim_create_autocmd('FileType', {
    pattern = {"python", "nix", "r", "quarto", "lua", "markdown", "html", "nu"},
    callback = function() vim.treesitter.start() end,
  })
      vim.lsp.config(
          "nixd",
          {
              settings = {
                  nixd = {
                      nixpkgs = {
                          expr = "import <nixpkgs> { }"
                      },
                      formatting = {
                          command = {"nixfmt"}
                      },
                      options = {
                          nixos = {
                              expr = '(builtins.getFlake "/tmp/NixOS_Home-Manager").nixosConfigurations.hostname.options'
                          },
                          home_manager = {
                              expr = '(builtins.getFlake "/tmp/NixOS_Home-Manager").homeConfigurations."user@hostname".options'
                          },
                          flake_parts = {
                              expr = 'let flake = builtins.getFlake ("/tmp/NixOS_Home-Manager"); in flake.debug.options // flake.currentSystem.options'
                          } 
    		      }
                  }
              }
          }
      )
      vim.lsp.config("pyright", {
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { '*' },
            },
          },
        },
      }
      )
      vim.lsp.config("r_language_server",{
      	settings = {
    	r = {
    	lsp = {
    		server_capabilitties = {
    		-- Those will be provided by cmp-r
    			completionProvider = false,
    			completionItemResolve = false,
    		}	
    	}
    	}
  	}
      })
      vim.lsp.config("lua_ls",{
      	settings = {
    	Lua = {
            workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
            }
    	}
    	}
    	}
      })
      vim.lsp.enable("nushell")
      vim.lsp.enable("pyright")
      vim.lsp.enable("nixd")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("ruff")
      vim.lsp.enable("r_language_server")
''
