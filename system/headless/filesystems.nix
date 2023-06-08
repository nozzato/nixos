{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    exfatprogs
    nfs-utils
    ventoy
    veracrypt
  ];
}
