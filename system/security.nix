{ config, lib, pkgs, ... }: {
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
}