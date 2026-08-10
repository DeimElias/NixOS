{ self, inputs, ... }:
{
  flake.nixosModules.laptopSpecifics =
    { pkgs, lib, ... }:
    {
      boot.initrd.luks.devices."luks-528734e7-567f-4bbd-8c43-647797ff4582".device =
        "/dev/disk/by-uuid/528734e7-567f-4bbd-8c43-647797ff4582";

      networking.hostName = "chimuelo";
      services.logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "lock";
        HandleLidSwitchDocked = "ignore";
      };
      hardware.logitech.wireless.enable = true;
      hardware.logitech.wireless.enableGraphical = true;
      services.auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };
      imports = [
        inputs.hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5
      ];

      services.calibre-web = {
        enable = true;
        package = inputs.stable.legacyPackages."${pkgs.stdenv.hostPlatform.system}".calibre-web;
        openFirewall = true;
        listen = {
          ip = "0.0.0.0";
          port = 8083;
        };
      };
      systemd.services.calibre-web.serviceConfig = {
        ReadWritePaths = [ "/mnt/ebooks/Calibre" ];
      };

      services.upower.enable = true;
      services.xserver.videoDrivers = [ "amdgpu" ];
      networking.firewall.allowedUDPPorts = [
        8083
        5353
      ];
      networking.firewall.allowedTCPPorts = [
        8083
        8069
      ];
    };
}
