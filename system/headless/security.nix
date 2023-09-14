{ config, lib, pkgs, ... }: {
  users.users.noah = {
    extraGroups = [ "wheel" ];
  };

  security.wrappers = {
    "mount.nfs4" = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.nfs-utils.out}/bin/mount.nfs4";
    };
    "umount.nfs4" = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.nfs-utils.out}/bin/umount.nfs4";
    };
  };

  security.sudo.extraRules = [{
    groups = [ "users" ];
    commands = [
      {
        command = "${pkgs.light}/bin/light";
        options = [ "NOPASSWD" ];
      }
    ];
  }];

  security.rtkit.enable = true;
}
