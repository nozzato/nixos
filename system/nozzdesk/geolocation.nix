{ config, lib, pkgs, ... }: {
  services.geoclue2 = {
    enable = true;
  };
}