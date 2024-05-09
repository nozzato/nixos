{ ... }: {
  fileSystems = {
    "/media/nozbox" = {
      device = "//192.168.1.6/noah";
      fsType = "cifs";
      options = [ "x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/etc/nixos/smb-nozbox-secrets,uid=1000,gid=100,dir_mode=0700,file_mode=0700" ];
    };
  };
}
