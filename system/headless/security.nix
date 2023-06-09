{ config, lib, pkgs, ... }: {
  users.users.noah = {
    extraGroups = [ "wheel" ];
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
