{ self, inputs, ... }:
{

  flake.nixosModules.printing =
    { pkgs, lib, ... }:
    {
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
          cups-zj-58
          epson-tm-t88vi
          epson-escpr2
        ];
        allowFrom = [ "all" ];
        browsing = true;
        defaultShared = true;
        openFirewall = true;
        extraConf = "DefaultEncryption Never";
      };
      services.samba.enable = true;
    };
}
