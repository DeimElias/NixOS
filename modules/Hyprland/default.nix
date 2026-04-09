{ self, inputs, ... }:
{

  flake.nixosModules.hyprland =
    { pkgs, lib, ... }:
    {
      services.displayManager.ly = {
        enable = true;
      };
      programs.hyprland = {
        enable = true;
        xwayland.enable = true; # Enable Xwayland for X applications
        withUWSM = true;
      };
      # screen recorder needed for Caelestia
      programs.gpu-screen-recorder.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          kdePackages.xdg-desktop-portal-kde
        ];
      };

      programs.uwsm.enable = true; # Recommended by Hyprland
      environment.systemPackages = [
        pkgs.crosspipe
        pkgs.pavucontrol
        pkgs.qalculate-gtk
        pkgs.kdePackages.okular
        pkgs.usbutils
        pkgs.mpv
        pkgs.impala
        inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      networking.wireless.iwd.enable = true; # requiered by impala
    };
}
