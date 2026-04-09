{ self, inputs, ... }:
{

  flake.nixosModules.driveSync =
    { pkgs, lib, ... }:
    {
      # GoogleDrive sync
      systemd.user.services.google-drive-ocamlfuse = {
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        description = "Google Drive mount service";
        serviceConfig = {
          Type = "forking";
          ExecStart = "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse -label default /home/chimuelo/GoogleDrive";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/chimuelo/GoogleDrive";
          Restart = "always";
        };
      };
      environment.systemPackages = [ pkgs.google-drive-ocamlfuse ];
    };
}
