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
        pkgs.blueman
        pkgs.dialog
        pkgs.libnotify
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.dolphin
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
