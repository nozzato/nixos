{ config, lib, pkgs, ... }: {
  networking.extraHosts = ''
    192.168.1.133 nozzdesk
    192.168.1.134 nozzbox
  '';

  services.openssh.enable = true;
}