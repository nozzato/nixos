{ config, lib, pkgs, ... }: {
  systemd.services."import-pools" = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.zfs}/bin/zpool import -a
    '';
  };
}
