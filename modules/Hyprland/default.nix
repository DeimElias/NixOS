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

      xdg.mime = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.kde.okular.desktop";
          "inode/directory" = [ "dolphin.desktop" ];
          "application/x-gnome-saved-search" = [ "dolphin.desktop" ];
        };
      };

      programs.uwsm.enable = true; # Recommended by Hyprland
      environment.systemPackages = [
        pkgs.crosspipe
        pkgs.pavucontrol
        pkgs.qalculate-gtk
        pkgs.kdePackages.okular
        pkgs.usbutils
        pkgs.mpv
        self.packages.${pkgs.stdenv.hostPlatform.system}.impala-wt
        inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      # networking.wireless.iwd.enable = true; # requiered by impala
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.impala-wt = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "impala-wt";
        version = "0.1.5";

        src = pkgs.fetchFromGitHub {
          owner = "aashish-thapa";
          repo = "wlctl";
          rev = "v0.1.5";
          hash = "sha256-omeRIERhax7lmBYcjKm2Vp32yTKvnkOEAgMhRL4/uUY=";
        };

        cargoHash = "sha256-8LTC5fRdwyXZD8EUz2gR0GTaZuldUTYF/WgAfpMsguM=";

        # fix for compilation of musl builds on aarch64
        # see https://github.com/NixOS/nixpkgs/issues/145726
        postPatch = ''
          rm .cargo/config.toml
        '';

      });
    };
}
