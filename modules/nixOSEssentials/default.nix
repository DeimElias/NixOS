{ self, inputs, ... }:
{

  flake.nixosModules.nixOSEssentials =
    { pkgs, lib, ... }:
    {
      networking.networkmanager.enable = true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      time.timeZone = "America/Mexico_City";

      i18n.defaultLocale = "en_US.UTF-8";

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      fonts.packages = [ pkgs.nerd-fonts.fira-code ];

      nixpkgs.config.allowUnfree = true;
      hardware.graphics = {
        enable = true;
      };
      users.users.chimuelo = {
        isNormalUser = true;
        description = "DeimElias";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "lpadmin"
        ];
        shell = pkgs.nushell;
        initialPassword = "test";
      };

      services.udisks2.enable = true; # USB Utilities

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Remap keys
      services.keyd = {
        enable = true;
        keyboards = {
          default = {
            ids = [ "*" ];
            settings = {
              main = {
                capslock = "layer(test)";
                control = "noop";
                esc = "noop";
              };
            };
            extraConfig = ''
              					  [test:C]
              					  [ = esc
              						  '';
          };
        };
      };

      i18n.supportedLocales = [ "all" ];
      # Use latest available kernel
      boot.kernelPackages = pkgs.linuxPackages_latest;

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      services.openssh.enable = true;

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true; # Show battery charge of Bluetooth devices
          };
        };
      };

      security.rtkit.enable = true;

      programs.nm-applet.enable = true;
      networking.firewall.enable = true;

      services.getty.autologinUser = "chimuelo";
      system.stateVersion = "25.05";
    };
}
