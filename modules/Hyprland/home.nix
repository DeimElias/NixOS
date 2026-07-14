{ self, inputs, ... }:
{
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
        configType = "lua";
        extraLuaFiles = {
          "zoom" =
            #lua
            ''
              function zoom_in()
                local current = hl.get_config("cursor.zoom_factor")
                if current < 1 then
                  current = 1
                end
                hl.config({ cursor = { zoom_factor = current * 1.25 } })
              end

              function zoom_out()
                local current = hl.get_config("cursor.zoom_factor")
                if current < 1 then
                  current = 1
                end
                local new_zoom = current / 1.25
                if new_zoom < 1 then
                  new_zoom = 1.0
                end
                hl.config({ cursor = { zoom_factor = new_zoom } })
              end

              function zoom_reset()
                hl.config({ cursor = { zoom_factor = 1.0 } })
              end

              hl.bind("SUPER + mouse_down", function()
                  zoom_in()
                  end)
              hl.bind("SUPER + mouse_up", function()
                  zoom_out()
                  end)
              hl.bind("SUPER + mouse:274", function()
                  zoom_reset()
                  end)
            '';
          animations =
            #lua
            ''
                          hl.config({
                  animations = {
                      enabled = true,
                  },
              })

              -- Animation curves
              hl.curve("specialWorkSwitch", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
              hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
              hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
              hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })

              -- Animation configs
              hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "emphasizedDecel", style = "popin" })
              hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "emphasizedAccel", style = "popin" })
              hl.animation({ leaf = "fadeLayers", enabled = true, speed = 2, bezier = "standard" })

              hl.animation({ leaf = "windowsIn", enabled = true, speed = 0.7, bezier = "emphasizedDecel", style = "gnomed"})
              hl.animation({ leaf = "windowsOut", enabled = true, speed = 0.7, bezier = "emphasizedAccel", style = "popin"})
              hl.animation({ leaf = "windowsMove", enabled = true, speed = 0.7, bezier = "standard" })
              hl.animation({ leaf = "workspaces", enabled = true, speed = 0.7, bezier = "standard" })

              hl.animation({
                  leaf    = "specialWorkspace",
                  enabled = true,
                  speed   = 1.5,
                  bezier  = "specialWorkSwitch",
                  style   = "fade"
              })
              hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "standard" })
              hl.animation({ leaf = "fadeDim", enabled = true, speed = 2, bezier = "standard" })
              hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "standard" })
            '';
        };
        settings =
          let
            lua = lib.generators.mkLuaInline;
          in
          {
            config = {
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
                kb_layout = "us";
                kb_variant = "altgr-intl";
                numlock_by_default = true;
              };

              binds = {
                disable_keybind_grabbing = true;
                scroll_event_delay = 8;
              };
            };
            on = {
              _args = [
                "hyprland.start"
                (lua ''function() hl.exec_cmd("${
                  lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.caelestia
                }") end'')
              ];
            };
            env = [
              {
                _args = [
                  "HYPRCURSOR_THEME"
                  "rose-pine-hyprcursor"
                ];
              }
              {
                _args = [
                  "HYPRCURSOR_SIZE"
                  "35"
                ];
              }
            ];
            bind = [
              {
                _args = [
                  "SUPER + mouse:272"
                  (lua "hl.dsp.window.drag()")
                  { mouse = true; }
                ];
              }
              {
                _args = [
                  "SUPER + mouse:273"
                  (lua "hl.dsp.window.resize()")
                  { mouse = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioRaiseVolume"
                  (lua ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")'')
                  {
                    repeating = true;
                    locked = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86AudioLowerVolume"
                  (lua ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'')
                  {
                    repeating = true;
                    locked = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86AudioMute"
                  (lua ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'')
                  {
                    repeating = true;
                    locked = true;
                  }
                ];
              }
              {
                _args = [
                  "switch:on:Lid Switch"
                  (lua ''hl.dsp.exec_cmd("hyprctl dispatch dpms off eDP-1")'')
                  { }
                ];
              }
              {
                _args = [
                  "switch:off:Lid Switch"
                  (lua ''hl.dsp.exec_cmd("hyprctl dispatch dpms on eDP-1")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86MonBrightnessUp"
                  (lua ''hl.dsp.global("caelestia:brightnessUp")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86MonBrightnessDown"
                  (lua ''hl.dsp.global("caelestia:brightnessDown")'')
                  { }
                ];
              }

              {
                _args = [
                  "XF86AudioPlay"
                  (lua ''hl.dsp.global("caelestia:mediaToggle")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioPause"
                  (lua ''hl.dsp.global("caelestia:mediaToggle")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioNext"
                  (lua ''hl.dsp.global("caelestia:mediaNext")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioPrev"
                  (lua ''hl.dsp.global("caelestia:mediaPrev")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioStop"
                  (lua ''hl.dsp.global("caelestia:mediaStop")'')
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "Print"
                  (lua ''hl.dsp.exec_cmd("caelestia screenshot")'')
                  { }
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + S"
                  (lua ''hl.dsp.global("caelestia:screenshot")'')
                  { }
                ];
              }
              {
                _args = [
                  "SUPER + P"
                  (lua ''hl.dsp.exec_cmd("hyprpicker -a")'')
                  { }
                ];
              }
              {
                _args = [
                  "SUPER"
                  (lua ''hl.dsp.global("caelestia:LaunherInterrupt")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + mouse:272"
                  (lua ''hl.dsp.global("caelestia:LaunherInterrupt")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + mouse:273"
                  (lua ''hl.dsp.global("caelestia:LaunherInterrupt")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + mouse:274"
                  (lua ''hl.dsp.global("caelestia:LaunherInterrupt")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + mouse:275"
                  (lua ''hl.dsp.global("caelestia:LaunherInterrupt")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + mouse:276"
                  (lua ''hl.dsp.global("caelestia:LaunherInterrupt")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + mouse:277"
                  (lua ''hl.dsp.global("caelestia:LaunherInterrupt")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + W"
                  (lua ''hl.dsp.exec_cmd("zen-beta")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + RETURN"
                  (lua ''hl.dsp.exec_cmd("ghostty")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + ALT + C"
                  (lua "hl.dsp.window.kill(\"activewindow\")")
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + C"
                  (lua "hl.dsp.window.close(\"activewindow\")")
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + B"
                  (lua ''hl.dsp.exec_cmd("overskride")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + R"
                  (lua ''hl.dsp.exec_cmd("sdl-freerdp /u:caja /p:1234 /v:10.238.0.25 /cert:ignore /dynamic-resolution +clipboard /t:Windows +unmap-buttons")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + E"
                  (lua ''hl.dsp.exec_cmd("sdl-freerdp /u:MyWindowsUser /p:MyWindowsPassword /v:127.0.0.1 /cert:ignore /dynamic-resolution +clipboard /t:Windows +drives /printer")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + S"
                  (lua ''hl.dsp.exec_cmd("localsend_app")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + Space"
                  (lua ''hl.dsp.workspace.toggle_special("special:special")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + F"
                  (lua "hl.dsp.window.float()")
                  { }
                ];
              }

              {
                _args = [
                  "SUPER + M"
                  (lua "hl.dsp.window.fullscreen()")
                  { }
                ];
              }
              {
                _args = [
                  "SUPER + T"
                  (lua ''hl.dsp.workspace.move({ monitor = "+1"})'')
                  { }
                ];

              }

              {
                _args = [
                  "SUPER + l"
                  (lua ''hl.dsp.focus({direction = "r"})'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + k"
                  (lua ''hl.dsp.focus({direction = "u"})'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + j"
                  (lua ''hl.dsp.focus({direction ="d"})'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + h"
                  (lua ''hl.dsp.focus({direction = "l"})'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + CTRL + l"
                  (lua ''hl.dsp.focus({workspace = "m+1"})'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + CTRL + h"
                  (lua ''hl.dsp.focus({workspace = "m-1"})'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + SHIFT +Space"
                  (lua ''hl.dsp.window.move({workspace = "special:special"})'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + X"
                  (lua ''hl.dsp.global("caelestia:session")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + SHIFT + L"
                  (lua ''hl.dsp.global("caelestia:lock")'')
                  { }
                ];

              }
              {
                _args = [
                  "SUPER + D"
                  (lua ''hl.dsp.global("caelestia:launcher")'')
                  { release = true; }
                ];
              }
            ]
            ++ (builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                  wss = ws + 4;
                in
                [
                  {
                    _args = [
                      "SUPER + code:1${toString i}"
                      (lua ''hl.dsp.focus({workspace = "${toString ws}"})'')
                    ];
                  }
                  {
                    _args = [
                      "SUPER + F${toString ws}"
                      (lua ''hl.dsp.focus({workspace = "${toString wss}"})'')
                    ];
                  }
                  {
                    _args = [
                      "SUPER + SHIFT + code:1${toString i}"
                      (lua ''hl.dsp.window.move({workspace = "${toString ws}"})'')
                    ];
                  }
                  {
                    _args = [
                      "SUPER + SHIFT + F${toString ws}"
                      (lua ''hl.dsp.window.move({workspace ="${toString wss}"})'')
                    ];
                  }
                ]
              ) 4
            ));
            gesture = {
              fingers = 3;
              direction = "horizontal";
              action = "workspace";
            };
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
            # material-symbols = pkgs.material-symbols.overrideAttrs (attrs: {
            #   postInstall = ''
            #     ln -s "$out/share/fonts/TTF/MaterialSymbolsRounded.ttf" "$out/share/fonts/TTF/MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf"
            #     ln -s "$out/share/fonts/TTF/MaterialSymbolsOutlined.ttf" "$out/share/fonts/TTF/MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf"
            #     ln -s "$out/share/fonts/TTF/MaterialSymbolsSharp.ttf" "$out/share/fonts/TTF/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf"
            #   '';
            # });
          };
    };

}
