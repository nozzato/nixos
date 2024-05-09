{ ... }: {
  networking = {
    hostName = "nozdesk";
    interfaces."enp39s0" = {
      ipv4.addresses = [{
        address = "192.168.1.3";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.1.254";
    nameservers = [ "192.168.1.254" ];
  };
}
