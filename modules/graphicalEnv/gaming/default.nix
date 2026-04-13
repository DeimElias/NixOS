{ self, inputs, ... }:
{

  flake.nixosModules.gaming =
    { pkgs, lib, ... }:
    {
      imports = [
        self.nixosModules.steam
        self.nixosModules.emulators
      ];
    };
}
