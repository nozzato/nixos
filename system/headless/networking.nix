{ config, lib, pkgs, ... }: {
  services.openssh.enable = true;

  networking.extraHosts = ''
    192.168.1.133 nozzdesk
    192.168.1.134 nozzbox
  '';
}