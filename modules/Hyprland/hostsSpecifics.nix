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
        hl.monitor({output="eDP-1", mode="1920x1200@60", position = "auto", scale = 1.2})
        hl.workspace_rule({workspace="r[1-4]", monitor = "eDP-1"})
        hl.workspace_rule({workspace="r[5-8]", monitor = "DP-1"})
        hl.on("workspace.created", function(ws)
           if not ws.is_empty then return end

           if ws.name == "special:Extra" then
             hl.exec_cmd("rustdesk --connect 10.238.0.25", { workspace = "special:Extra silent" })
           end
        end)
      '';
    };

  flake.homeModules.PCHyprlandExtraConf =
    {
      pkgs,
      lib,
      ...
    }:
    {
      wayland.windowManager.hyprland.extraConfig = ''
        hl.monitor({output="DP-2", mode="2560x1440@143.91", position = "auto", scale = 1})
        hl.monitor({output="HDMI-A-1", mode="3840x2160@60", position = "auto", scale = 1.25})
      '';
    };
}
