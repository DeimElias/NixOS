{ self, inputs, ... }:
{

  flake.nixosModules.graphicalEnvEssentials =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        pkgs.discord

        (pkgs.freerdp.override { withWaylandSupport = true; })

        inputs.stable.legacyPackages."${pkgs.stdenv.hostPlatform.system}".calibre
        pkgs.libreoffice-qt6-fresh
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

      environment.unixODBCDrivers = with pkgs.unixodbcDrivers; [
        sqlite
        psql
        msodbcsql17
        msodbcsql18
        psql
      ];

    };
}
