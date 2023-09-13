{ config, lib, pkgs, ... }: {
  networking = {
    interfaces."enp39s0".ipv4.addresses = [{
      address = "192.168.1.97";
      prefixLength = 24;
    }];
    enableIPv6 = false;
    defaultGateway = "192.168.1.254";
    nameservers = [ "192.168.1.254" ];
  };
  systemd.services."restart-network-addresses-enp39s0" = {
    wantedBy = [ "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.systemd}/bin/systemctl restart network-addresses-enp39s0.service
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 8000 ];
  };
}
