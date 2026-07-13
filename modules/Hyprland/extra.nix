{ self, inputs, ... }:
{
  flake.homeModules.hyprExtra =
    {
      pkgs,
      lib,
      ...
    }:
    {
      home.packages = [
        pkgs.overskride
        pkgs.dialog
        pkgs.libnotify
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.dolphin
        pkgs.kdePackages.plasma-workspace
      ];
      services.udiskie = {
        enable = true;
        settings = {
          program_options = {
            file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
          };
        };
      };

    };
}
