{ self, inputs, ... }:
{
  flake.homeModules.shell =
    { pkgs, lib, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user.email = "deimelias@gmail.com";
          user.name = "DeimElias";
        };
      };

      programs.nushell = {
        enable = true;
        package = null;
        settings = {
          show_banner = false;
          edit_mode = "vi";
        };
        extraConfig =
          # nu
          ''
                        $env.PROJECTS = '/home/chimuelo/Projects/'
                        $env.EDITOR = 'nvim'
                        if (which tmux | is-not-empty) and not ('TMUX' in $env) {
                        	exec tmux new-session -A -s main
                        }
                        $env.config.keybindings ++= [{
                          modifier: control
                          keycode: char_y
                          mode: vi_insert
                          event: {
                            send: HistoryHintWordComplete
                          }
                        }]
            			use std/config *
            			$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

            			$env.config.hooks.env_change.PWD ++= [{||
            				if (which direnv | is-empty) {
                        # If direnv isn't installed, do nothing
            					return
            				}

            				direnv export json | from json | default {} | load-env
                        # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
            				$env.PATH = do (env-conversions).path.from_string $env.PATH
            			}]
            			'';
      };

      programs.carapace = {
        enable = true;
        enableNushellIntegration = true;
      };

      programs.starship = {
        enable = true;
        enableNushellIntegration = true;
        settings = (pkgs.lib.importTOML ./starship);
      };
      home.packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
      ];
      home.file.".config/direnv/direnv.toml".text = ''
        [global]
        hide_env_diff = true
        warn_timeout = 0
      '';
    };
}
