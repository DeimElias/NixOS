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
        pkgs.qbz
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

      imports = [
        inputs.preload-ng.nixosModules.default
      ];
      services.preload-ng.enable = true;
      services.preload-ng.settings = {
        # Faster cycles for NVMe responsiveness
        cycle = 15;

        # Memory tuning for 16GB RAM
        memTotal = -25;
        memFree = 70;
        memCached = 10;
        memBuffers = 50;

        # Track smaller files (1MB min)
        minSize = 1000000;

        # More parallelism (Ryzen 5600G)
        processes = 60;

        # No sorting needed for NVMe (no seek penalty)
        sortStrategy = 0;

        # Save state every 30 min
        autoSave = 1800;

        # NixOS-specific paths (Already implemented on preload-ng flake)
        mapPrefix = "/nix/store/;/run/current-system/;!/";
        exePrefix = "/nix/store/;/run/current-system/;!/";
      };
      environment.unixODBCDrivers = with pkgs.unixodbcDrivers; [
        sqlite
        psql
        msodbcsql17
        msodbcsql18
        psql
      ];

    };
}
