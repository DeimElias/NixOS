{ self, inputs, ... }:
{

  flake.homeModules.winApps =
    { pkgs, lib, ... }:
    {
      home.file = {
        ".config/winapps/winapps.conf".source = ./winapps.conf;
      };
    };
}
