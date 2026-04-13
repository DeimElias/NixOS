{ self, inputs, ... }:
{

  flake.nixosModules.laptopConfiguration_Plasma =
    { pkgs, lib, ... }:
    {
      # import any other modules from here
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.nixOSEssentials

        # laptop modules
        self.nixosModules.laptopHardware
        self.nixosModules.laptopHome_Plasma
        self.nixosModules.laptopSpecifics

        # General modules
        self.nixosModules.graphicalEnvEssentials
        self.nixosModules.driveSync
        self.nixosModules.printing
        self.nixosModules.winApps
        self.nixosModules.plasma
        self.nixosModules.gaming
      ];
    };

  flake.nixosModules.laptopHome_Plasma =
    { pkgs, lib, ... }:
    {

      home-manager.useUserPackages = true;
      home-manager.users.chimuelo = {
        imports = [
          # Default Modules
          self.homeModules.homeEssentials
          self.homeModules.graphicalEnv

          # General Modules
          self.homeModules.winApps
        ];
      };
    };

}
