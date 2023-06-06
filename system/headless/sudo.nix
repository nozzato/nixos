{ config, lib, pkgs, ... }: {
  security.sudo.extraRules = [{
    groups = [ "users" ];
    commands = [
      {
        command = "${pkgs.light}/bin/light";
        options = [ "NOPASSWD" ];
      }
    ];
  }];
  users.users.noah = {
    extraGroups = [ "wheel" ];
  };
}
