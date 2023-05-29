{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
}