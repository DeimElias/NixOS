{ self, inputs, ... }:
{

  flake.nixosModules.laptopConfiguration =
    { pkgs, lib, ... }:
    {
      # import any other modules from here
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.nixOSEssentials

        # laptop modules
        self.nixosModules.laptopHardware
        self.nixosModules.laptopHome
        self.nixosModules.laptopSpecifics

        # General modules
        self.nixosModules.graphicalEnvEssentials
        self.nixosModules.driveSync
        self.nixosModules.printing
        self.nixosModules.winApps
        self.nixosModules.hyprland
      ];
    };

  flake.nixosModules.laptopHome =
    { pkgs, lib, ... }:
    {

      home-manager.useUserPackages = true;
      home-manager.users.chimuelo = {
        imports = [
          # Default Modules
          self.homeModules.homeEssentials

          # General Modules
          self.homeModules.hyprland
          self.homeModules.winApps
        ];
      };
    };

}
