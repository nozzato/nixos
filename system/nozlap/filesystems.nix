{ config, lib, pkgs, ... }: {
  fileSystems = {
    "/media/share" = {
      label = "share";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=033" ];
    };
    "/media/store" = {
      device = "nozbox:/box/store";
      fsType = "nfs";
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
