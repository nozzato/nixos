{ config, lib, pkgs, ... }: {
  networking.firewall = {
    allowedTCPPorts = [ 8000 ];
  };
}
