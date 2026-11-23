{ self, inputs, ... }:
{

  flake.nixosModules.driveSync =
    { pkgs, lib, ... }:
    {
      # GoogleDrive sync
      systemd.user.services.google-drive-ocamlfuse = {
        description = "Google Drive mount service";
        enable = true;
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "default.target" ];
        restartIfChanged = false;

        path = [
          "/run/wrappers"
          pkgs.fuse3
        ];

        serviceConfig = {
          Type = "exec";
          ExecStart = "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse -label default %h/GoogleDrive";
          ExecStop = "-/run/wrappers/bin/fusermount3 -u %h/GoogleDrive";
          Restart = "always";
          RestartSec = "5s";
          TimeoutStartSec = "15s";
          TimeoutStopSec = "15s";
        };
      };
      environment.systemPackages = [ pkgs.google-drive-ocamlfuse ];
    };
}
