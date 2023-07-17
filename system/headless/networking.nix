{ config, lib, pkgs, ... }: {
  networking = {
    networkmanager.enable = true;
    extraHosts = ''
      192.168.1.134 nozbox
    '';
  };
  users.users.noah = {
    extraGroups = [ "networkmanager" ];
  };

  services.openssh.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ 22 ];
  };
}
