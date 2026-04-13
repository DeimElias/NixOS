{ self, inputs, ... }:
{
  flake.nixosConfigurations.tower = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.PCconfiguration
    ];
  };
}
