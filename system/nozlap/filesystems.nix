{ config, lib, pkgs, ... }: {
  fileSystems = {
    "/media/windows" = {
      label = "windows";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=100" "dmask=022" "fmask=033" ];
    };
    "/media/share" = {
      label = "share";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=100" "dmask=022" "fmask=033" ];
    };
    "/media/attic" = {
      device = "nozbox:/media/attic";
      fsType = "nfs4";
      options = [ "noauto" "user" "_netdev" "bg" ];
    };
  };
  systemd.tmpfiles.rules = [
    "d /mnt"
  ];
  swapDevices = [
    {
      label = "swap";
    }
  ];
}
