{ self, inputs, ... }:
{
  flake.nixosModules.PCSpecifics =
    { pkgs, lib, ... }:
    {
      networking.hostName = "adolin";
      services.xserver.videoDrivers = [ "amdgpu" ];
      fileSystems."/home/chimuelo/Steam" = {
        device = "/dev/disk/by-uuid/ba41dd82-c304-4fae-88ad-4fe2212da20a";
        fsType = "ext4";
      };
    };
}
