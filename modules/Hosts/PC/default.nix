{ self, inputs, ... }:
{
  flake.nixosConfigurations.tower = inputs.nixpkgs.lib.nixosSystem {
    modules = [
<<<<<<< HEAD
      self.nixosModules.PCConfiguration
=======
      self.nixosModules.PCconfiguration
>>>>>>> 4fe61ac (IMPORTANT Rewriting, using Flake-parts and modules)
    ];
  };
}
