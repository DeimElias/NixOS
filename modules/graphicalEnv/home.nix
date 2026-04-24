{ self, inputs, ... }:
{

  flake.homeModules.graphicalEnv =
    { pkgs, lib, ... }:
    {
      imports = [
        self.homeModules.ghostty
        self.inputs.zen-browser.homeModules.beta
      ];
      stylix.targets.zen-browser.profileNames = [ "default" ];
      programs.zen-browser.enable = true;
    };
}
