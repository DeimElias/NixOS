{ self, inputs, ... }:
{

  flake.nixosModules.steam =
    { pkgs, lib, ... }:
    {
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      programs.gamemode.enable = true;
    };
}
