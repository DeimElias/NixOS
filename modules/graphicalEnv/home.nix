{ self, inputs, ... }:
{

  flake.homeModules.graphicalEnv =
    { pkgs, lib, ... }:
    {
      imports = [ self.homeModules.ghostty ];
    };
}
