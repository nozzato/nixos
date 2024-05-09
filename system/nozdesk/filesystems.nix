{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/68853943-689a-48a8-b912-9f3f45ed6e15";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/68A8-95CB";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };
}
