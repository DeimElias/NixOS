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
<<<<<<< HEAD
        self.nixosModules.PCHardware
        self.nixosModules.PCHome
        self.nixosModules.PCSpecifics
=======
        # self.nixosModules.PCHardware
        self.nixosModules.PCHome
        # self.nixosModules.PCSpecifics
>>>>>>> 4fe61ac (IMPORTANT Rewriting, using Flake-parts and modules)
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
<<<<<<< HEAD
      home-manager.useUserPackages = true;
      home-manager.users.chimuelo = {
        imports = [
          # Default Modules
          self.homeModules.homeEssentials
          self.homeModules.PCHyprlandExtraConf
=======

      home-manager.useUserPackages = true;
      home-manager.users.adolin = {
        imports = [
          # Default Modules
          self.homeModules.homeEssentials
	  # self.homeModules.PCHyprlandExtraConf
>>>>>>> 4fe61ac (IMPORTANT Rewriting, using Flake-parts and modules)
          self.homeModules.graphicalEnv

          # General Modules
          self.homeModules.hyprland
          self.homeModules.winApps
        ];
      };
    };

}
