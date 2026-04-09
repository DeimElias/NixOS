{ self, inputs, ... }:
{
  flake.nixosConfigurations.chimuelo = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopConfiguration
    ];
  };
}
