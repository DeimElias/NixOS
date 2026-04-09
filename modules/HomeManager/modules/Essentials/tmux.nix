{ self, inputs, ... }:
{
  flake.homeModules.tmux =
    { pkgs, lib, ... }:
    {
      programs.tmux = {
        baseIndex = 1;
        customPaneNavigationAndResize = true;
        enable = true;
        keyMode = "vi";
        terminal = "screen-256color";
        extraConfig =
          let
            conf = (builtins.readFile ./nuscripts/config.nu);
            project = (builtins.readFile ./nuscripts/projects.nu);
            fbtop = (builtins.readFile ./nuscripts/fbtop.nu);
          in
          ''
                            bind p run-shell "nu ${pkgs.writeText "project.nu" project}"
                            bind o run-shell "nu ${pkgs.writeText "config.nu" conf}"
                            bind i run-shell "nu ${pkgs.writeText "fbtop.nu" fbtop}"
                    		set-option -g status-position top
            				bind-key -n M-1 select-window -t 1
            				bind-key -n M-2 select-window -t 2
            				bind-key -n M-3 select-window -t 3
            				bind-key -n M-4 select-window -t 4
            				bind-key -n M-5 select-window -t 5
            				bind-key -n M-6 select-window -t 6
            				bind-key -n M-7 select-window -t 7
            				bind-key -n M-8 select-window -t 8
            				bind-key -n M-9 select-window -t 9
            				bind-key -n M-0 select-window -t 0
          '';
        plugins = [
          {
            plugin = self.packages.${pkgs.stdenv.hostPlatform.system}.tokyonight-tmux;
            extraConfig = ''
                        set -g @theme_plugins 'datetime,battery'
              set -g @theme_left_separator ''
              set -g @theme_right_separator ''
                        set -g @theme_transparent_status_bar 'true'
                        set -g @theme_transparent_left_separator_inverse ''
                        set -g @theme_transparent_right_separator_inverse ''
            '';
          }
        ];
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.tokyonight-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tokyonight-tmux";
        rtpFilePath = "tmux-tokyo-night.tmux";
        version = "1.11";
        src = pkgs.fetchFromGitHub {
          owner = "fabioluciano";
          repo = "tmux-tokyo-night";
          rev = "97cdce3e785f8a6cc1c569b87cd3020fdad7e637";
          hash = "sha256-WjDbunWmxbw/jjvc34ujOWif18POC3WVO1s+hk9SLg4=";
        };
      };
    };
}
