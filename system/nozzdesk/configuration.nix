{ config, lib, pkgs, ... }: {
  programs.dconf = {
    enable = true;
  };
  services.geoclue2 = {
    enable = true;
  };
  programs.npm = {
    enable = true;
  };
}
