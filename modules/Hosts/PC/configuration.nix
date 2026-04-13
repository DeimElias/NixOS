{ self, inputs, ... }:
{

  flake.nixosModules.PCConfiguration =
    { pkgs, lib, ... }:
    {
      # import any other modules from here
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.nixOSEssentials

        # laptop modules
        self.nixosModules.PCHardware
        self.nixosModules.PCHome
        self.nixosModules.PCSpecifics
        #
        # General modules
        self.nixosModules.graphicalEnvEssentials
        self.nixosModules.driveSync
        self.nixosModules.printing
        self.nixosModules.winApps
        self.nixosModules.hyprland
        self.nixosModules.gaming
      ];
    };

  flake.nixosModules.PCHome =
    { pkgs, lib, ... }:
    {
      home-manager.useUserPackages = true;
      home-manager.users.chimuelo = {
        imports = [
          # Default Modules
          self.homeModules.homeEssentials
          self.homeModules.PCHyprlandExtraConf
          self.homeModules.graphicalEnv

          # General Modules
          self.homeModules.hyprland
          self.homeModules.winApps
        ];
      };
    };

}
