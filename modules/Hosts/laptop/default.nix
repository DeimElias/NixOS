{ self, inputs, ... }:
{
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopConfiguration
    ];
  };

  flake.nixosConfigurations.laptop_plasma = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopConfiguration_Plasma
    ];
  };

}
