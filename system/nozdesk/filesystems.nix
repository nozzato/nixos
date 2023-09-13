{ config, lib, pkgs, ... }: {
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "bf7a6004";
  boot.zfs.forceImportRoot = false;
  boot.zfs.allowHibernation = true;
  services.zfs.autoScrub.enable = true;

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
    "d /media/active"
    "d /mnt"
  ];
  swapDevices = [
    {
      label = "swap";
    }
  ];
}
