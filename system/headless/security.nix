{ config, lib, pkgs, ... }: {
  users.users.noah = {
    extraGroups = [ "wheel" ];
  };

  security.wrappers = {
    "mount".source = "${pkgs.utillinux}/bin/mount";
    "umount".source = "${pkgs.utillinux}/bin/umount";
    "mount.nfs4" = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.nfs-utils.out}/bin/mount.nfs4";
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
