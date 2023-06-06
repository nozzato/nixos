{ config, lib, pkgs, ... }: {
  networking = {
    networkmanager.enable = true;
    extraHosts = ''
      192.168.1.133 nozzdesk
      192.168.1.134 nozzbox
    '';
  };
  time.timeZone = "Europe/London";

  services.openssh.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ 22 ];
  };
}
