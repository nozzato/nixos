{ config, lib, pkgs, ... }: {
  programs.adb.enable = true;
  users.users.noah = {
    extraGroups = [ "adbusers" ];
  };
}
