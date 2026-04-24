{ self, inputs, ... }:
{
  flake.homeModules.laptopHyprlandExtraConf =
    {
      pkgs,
      lib,
      ...
    }:
    {
      wayland.windowManager.hyprland.extraConfig = ''
        monitor = DP-1, preferred, auto, 1
        monitor = eDP-1, preferred, auto, 1
        workspace = r[1-4], monitor:eDP-1
        workspace = r[5-8], monitor:DP-1
        workspace = special:special, on-created-empty: "sdl-freerdp /u:caja /p:1234 /v:10.238.0.25 /cert:ignore /dynamic-resolution +clipboard /t:Windows +unmap-buttons"
        workspace = 5, default:true
      '';
    };
  flake.homeModules.hyprland =
    {
      pkgs,
      lib,
      ...
    }:
    {

      wayland.windowManager.hyprland = {
        enable = true;
        package = null; # Use the one provided by NixosConfs
        portalPackage = null; # Same as above
        settings = {
          misc = {
            force_default_wallpaper = 1;
          };
          cursor = {
            inactive_timeout = 2;
            warp_on_change_workspace = 1;
            hide_on_key_press = true;
          };
          exec-once = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.caelestia}";

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
            "HYPRCURSOR_THEME,rose-pine-hyprcursor"
            "HYPRCURSOR_SIZE,35"
          ];
          "$mod" = "SUPER";
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow"
          ];
          binde =
            let
              script = (builtins.readFile ./zoom.nu);

              zoom = pkgs.writeText "zoom.nu" script;
            in
            [
              "$mod, mouse:274, exec, hyprctl keyword cursor:zoom_factor 1.0"
              "$mod, code:20, exec, nu ${zoom} -0.3"
              "$mod, code:21, exec, nu ${zoom} 0.3"
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
          ];
          bindr = "SUPER, D, global, caelestia:launcher";
          bind = [
            "$mod, W, exec, zen-beta"
            "$mod, RETURN, exec, ghostty"
            "$mod, C, killactive,"
            "$mod+SHIFT, C, forcekillactive,"
            "$mod, B, exec, blueman-manager"
            "$mod, R, exec, sdl-freerdp /u:caja /p:1234 /v:10.238.0.25 /cert:ignore /dynamic-resolution +clipboard /t:Windows +unmap-buttons"
            "$mod, E, exec, sdl-freerdp /u:MyWindowsUser /p:MyWindowsPassword /v:127.0.0.1 /cert:ignore /dynamic-resolution +clipboard /t:Windows +drives /printer"
            "$mod, S, exec, localsend_app"
            "$mod, Space, togglespecialworkspace, special:special"
            "$mod, F, togglefloating"
            "$mod, code:60, pin"
            "$mod, M, fullscreen"
            "$mod, T, movecurrentworkspacetomonitor, +1"

            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"
            "$mod, h, movefocus, l"

            "$mod+Ctrl, l, workspace, m+1"
            "$mod+Ctrl, h, workspace, m-1" # Special configuration for each system

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
      ];
      imports = [
        self.homeModules.hyprExtra
      ];
    };
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.caelestia =
        inputs.shell.packages.${pkgs.stdenv.hostPlatform.system}.caelestia-shell.override
          {
            app2unit = pkgs.app2unit;
            material-symbols = pkgs.material-symbols.overrideAttrs (attrs: {
              postInstall = ''
                ln -s "$out/share/fonts/TTF/MaterialSymbolsRounded.ttf" "$out/share/fonts/TTF/MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf"
                ln -s "$out/share/fonts/TTF/MaterialSymbolsOutlined.ttf" "$out/share/fonts/TTF/MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf"
                ln -s "$out/share/fonts/TTF/MaterialSymbolsSharp.ttf" "$out/share/fonts/TTF/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf"
              '';
            });
          };
    };

}
