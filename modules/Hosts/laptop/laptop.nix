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

      services.upower.enable = true;
      networking.firewall.allowedUDPPorts = [
        5353
      ];
      networking.firewall.allowedTCPPorts = [ 8069 ];
    };
}
