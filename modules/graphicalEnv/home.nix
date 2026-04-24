{ self, inputs, ... }:
{

  flake.homeModules.graphicalEnv =
    { pkgs, lib, ... }:
    {
      imports = [
        self.homeModules.ghostty
        self.inputs.zen-browser.homeModules.beta
      ];
      programs.zen-browser.enable = true;
    };
}
