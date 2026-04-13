{ self, inputs, ... }:
{

  flake.nixosModules.steam =
    { pkgs, lib, ... }:
    {
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      hardware.opengl = {
        enable = true;
        driSupport32Bit = true;
      };
      programs.gamemode.enable = true;
    };
}
