{ self, inputs, ... }:
{

  flake.nixosModules.emulators =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        pkgs.eden
      ];
    };
}
