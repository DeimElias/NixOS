{ self, inputs, ... }:
{

  flake.nixosModules.style =
    { pkgs, lib, ... }:
    {
      stylix.enable = true;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
      stylix.targets.plymouth.enable = false;
    };
}
