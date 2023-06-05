{ config, lib, pkgs, ... }: {
  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [];
    };
  };

  time.timeZone = "Europe/London";
}