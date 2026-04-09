{ self, inputs, ... }:
{

  flake.nixosModules.graphicalEnvEssentials =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        pkgs.discord

        (pkgs.freerdp.override { withWaylandSupport = true; })

        inputs.stable.legacyPackages."${pkgs.stdenv.hostPlatform.system}".calibre
        inputs.zen.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        jack.enable = true;
      };

      security.polkit.enable = true;
      programs.localsend.enable = true;
    };
}
