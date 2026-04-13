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

  flake.homeModules.PCHyprlandExtraConf =
    {
      pkgs,
      lib,
      ...
    }:
    {
      wayland.windowManager.hyprland.extraConfig = ''
        monitor = DP-2, 2560x1440@143.91, auto, 1
      '';
    };
}
