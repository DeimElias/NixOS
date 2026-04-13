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
      imports = [
        inputs.hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5
      ];

      services.upower.enable = true;
      services.xserver.videoDrivers = [ "amdgpu" ];
      networking.firewall.allowedUDPPorts = [
        5353
      ];
      networking.firewall.allowedTCPPorts = [ 8069 ];
    };
}
