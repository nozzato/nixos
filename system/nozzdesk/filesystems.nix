{ config, lib, pkgs, ... }: {
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "bf7a6004";
  services.zfs.autoScrub.enable = true;

  fileSystems = {
    "/media/windows" = {
      label = "windows";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=033" ];
    };
    "/media/share" = {
      label = "share";
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
