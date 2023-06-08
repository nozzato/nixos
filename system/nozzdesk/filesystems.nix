{ config, lib, pkgs, ... }: {
  fileSystems = {
    "/media/share" = {
      label = "share";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=033" ];
    };
    "/media/windows" = {
      label = "windows";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=033" ];
    };
    "/media/store" = {
      device = "nozzbox:/box/store";
      fsType = "nfs";
      options = [ "noauto" "user" "_netdev" "bg" ];
    };
  };
  systemd.tmpfiles.rules = [
    "d /media/active"
    "d /mnt"
  ];
  swapDevices = [
    {
      label = "swap";
    }
  ];
}
