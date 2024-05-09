{ ... }: {
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
  };
}
