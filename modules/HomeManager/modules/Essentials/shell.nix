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
        extraConfig = ''
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
                	}
          		]
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
    };
}
