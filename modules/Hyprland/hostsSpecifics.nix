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
        hl.workspace_rule({workspace="r[1-4]", monitor = "eDP-1"})
        hl.workspace_rule({workspace="r[5-8]", monitor = "DP-1"})
        hl.workspace_rule({workspace="special:special", on_created_empty= "sdl-freerdp /u:caja /p:1234 /v:10.238.0.25 /cert:ignore /dynamic-resolution +clipboard /t:Windows +unmap-buttons"})
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
      '';
    };
}
