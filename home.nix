{
  config,
  pkgs,
  zen,
  ...
}:
{
  home.username = "chimuelo";
  home.homeDirectory = "/home/chimuelo";
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    systemd.enable = true;
    settings = {
      services.useFahrenheit = false;
      dashboard.showOnHover = false;
      notifs.actionOnClick = true;
      bar.entries = [
        {
          id = "logo";
          enabled = true;
        }
        {
          id = "workspaces";
          enabled = true;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "activeWindow";
          enabled = false;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "tray";
          enabled = false;
        }
        {
          id = "clock";
          enabled = true;
        }
        {
          id = "statusIcons";
          enabled = true;
        }
        {
          id = "power";
          enabled = true;
        }
      ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      misc = {
        force_default_wallpaper = 1;
      };
      cursor = {
        inactive_timeout = 2;
        warp_on_change_workspace = 1;
        hide_on_key_press = true;
      };
      decoration = {
        rounding = 10;
      };
      input = {
        numlock_by_default = true;
      };
      binds = {
        disable_keybind_grabbing = true;
      };
      env = [
        "SDL_VIDEODRIVER,wayland"
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,35"
      ];
      "$mod" = "SUPER";
      monitor = [
        "eDP-1, preferred, auto, 1"
        "DP-1, preferred, auto, 1"
      ];
      workspace = (
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
              wss = ws + 4;
            in
            [
              "${toString ws}, monitor:eDP-1"
              "${toString wss}, monitor:DP-1"
            ]
          ) 4
        )

      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      gesture = " 3, horizontal, workspace";
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",switch:on:Lid Switch, exec, hyprctl dispatch dpms off eDP-1"
        ",switch:off:Lid Switch, exec, hyprctl dispatch dpms on eDP-1"
        ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
        ", XF86MonBrightnessDown, global, caelestia:brightnessDown"

        # Media
        ", XF86AudioPlay, global, caelestia:mediaToggle"
        ", XF86AudioPause, global, caelestia:mediaToggle"
        ", XF86AudioNext, global, caelestia:mediaNext"
        ", XF86AudioPrev, global, caelestia:mediaPrev"
        ", XF86AudioStop, global, caelestia:mediaStop"
        ", Print, exec, caelestia screenshot"
        "$mod+Shift, S, global, caelestia:screenshot"
        "$mod, P, exec, hyprpicker -a"
      ];
      bindin = [
        "$mod, cachall, global, caelestia:LaunherInterrupt"
        "$mod, mouse:272, global, caelestia:LaunherInterrupt"
        "$mod, mouse:273, global, caelestia:LaunherInterrupt"
        "$mod, mouse:274, global, caelestia:LaunherInterrupt"
        "$mod, mouse:275, global, caelestia:LaunherInterrupt"
        "$mod, mouse:276, global, caelestia:LaunherInterrupt"
        "$mod, mouse:277, global, caelestia:LaunherInterrupt"
        "$mod, mouse_up, global, caelestia:LaunherInterrupt"
        "$mod, mouse_down, global, caelestia:LaunherInterrupt"
      ];
      bindr = "SUPER, D, global, caelestia:launcher";
      bind = [
        "$mod, W, exec, zen"
        "$mod, RETURN, exec, ghostty"
        "$mod, C, killactive,"
        "$mod+SHIFT, C, forcekillactive,"
        "$mod, B, exec, blueman-manager"
        "$mod, R, exec, sdl3-freerdp /u:caja /p:1234 /v:10.238.103.31 /cert:ignore /dynamic-resolution +clipboard /t:Windows +unmap-buttons"
        "$mod, E, exec, sdl3-freerdp /u:MyWindowsUser /p:MyWindowsPassword /v:127.0.0.1 /cert:ignore /dynamic-resolution +clipboard /t:Windows +unmap-buttons /printer"
        "$mod, S, exec, localsend_app"
        "$mod, Space, exec, caelestia toggle specialws"
        "$mod, F, togglefloating"
        "$mod, code:60, pin"
        "$mod, M, fullscreen"
        "$mod, T, movecurrentworkspacetomonitor, +1"

        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        "$mod, h, movefocus, l"

        "$mod+Ctrl, l, workspace, m+1"
        "$mod+Ctrl, h, workspace, m-1"

        "$mod+Shift, Space, movetoworkspace, special:special"
        "$mod, X, global, caelestia:session"
        "$mod+SHIFT, L, global, caelestia:lock"

      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
            wss = ws + 4;
          in
          [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod, F${toString ws}, workspace, ${toString wss}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            "$mod SHIFT, F${toString ws}, movetoworkspace, ${toString wss}"
          ]
        ) 4
      ));
    };
  };

  home.packages = [
    pkgs.hyprpicker
    zen.packages.${pkgs.system}.default
    pkgs.blueman
    pkgs.dialog
    pkgs.libnotify
    pkgs.bat
    pkgs.fzf
    pkgs.gpu-screen-recorder
  ];
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

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "TokyoNight Storm";
      font-size = 15;
      gtk-tabs-location = "hidden";
      clipboard-read = "allow";
      clipboard-write = "allow";
      window-padding-x = "10";
      window-padding-y = "12,0";
      font-family = "FiraCode Nerd Font Mono";
      background-opacity = 0.85;
    };
  };
  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
      };
    };
  };

  programs.tmux = {
    baseIndex = 1;
    customPaneNavigationAndResize = true;
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig =
      let
        conf = (builtins.readFile ./nuscrips/config.nu);
        project = (builtins.readFile ./nuscrips/projects.nu);
      in
      ''
        bind p run-shell "nu ${pkgs.writeText "project.nu" project}"
        bind o run-shell "nu ${pkgs.writeText "config.nu" conf}"
      '';
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.tokyonight-tmux;
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

  home.file = {
    ".config/nushell/scrips/projects.nu".source = ./nuscrips/projects.nu;
    ".config/winapps/winapps.conf".source = ./winapps/winapps.conf;
  };
  home.shell.enableNushellIntegration = true;

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
