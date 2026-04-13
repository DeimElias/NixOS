{ self, inputs, ... }:
{

  flake.nixosModules.plasma =
    { pkgs, lib, ... }:
    {
      services.displayManager.sddm = {
        enable = true;
      };
      services.desktopManager.plasma6.enable = true;
    };
}
