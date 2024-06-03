{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  services.qemuGuest.enable = true;

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4830a0ea-cf9b-42b2-9f1e-63cf7c83cd50";
      fsType = "ext4";
    };
    "/mnt/secrets" = {
      device = "/dev/disk/by-uuid/32dcd557-1f1b-40da-824f-ce4501f2462a";
      fsType = "f2fs";
    };
  };

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
  };
  networking.hostId = "2cb35791";
  services.zfs.autoScrub.enable = true;
  systemd.services."zfs-mount" = {
    description = "ZFS mounts";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.zfs}/bin/zpool import -a
      ${pkgs.zfs}/bin/zfs load-key -r tank
      ${pkgs.zfs}/bin/zfs mount -a
    '';
  };
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    daily = 31;
  };

  sops.secrets = {
    "system/nozbox/user_noah_password" = {
      neededForUsers = true;
    };
  };
  users.users = {
    noah = {
      hashedPasswordFile = config.sops.secrets."system/nozbox/user_noah_password".path;
    };
    jodie = {
      isNormalUser = true;
      uid = 1001;
      description = "Jodie Torrance";
      createHome = false;
    };
    bella = {
      isNormalUser = true;
      uid = 1002;
      description = "Bella Torrance";
      createHome = false;
    };
    jos = {
      isNormalUser = true;
      uid = 1003;
      description = "Jos Morgans";
      createHome = false;
    };
  };
  system.activationScripts.linkHome = lib.stringAfter [ "var" ] ''
    ln -snf /tank/jodie /home/jodie
    ln -snf /tank/bella /home/bella
    ln -snf /tank/jos /home/jos
  '';

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "podman";

  networking = {
    hostName = "nozbox";
    useDHCP = false;
    interfaces = {
      "ens18" = {
        ipv4.addresses = [{
          address = "192.168.1.6";
          prefixLength = 24;
        }];
      };
    };
    enableIPv6 = false;
    defaultGateway = "192.168.1.254";
    nameservers = [ "192.168.1.254" ];
  };

  sops.secrets = {
    "system/nozbox/ddns_password" = { };
  };
  systemd.timers.ddns = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/30";
      Unit = "ddns.service";
    };
  };
  systemd.services.ddns = {
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.curl}/bin/curl "https://dynamicdns.park-your-domain.com/update?host=@&domain=nozato.org&password=$(cat ${config.sops.secrets."system/nozbox/ddns_password".path})"
    '';
  };

  sops.secrets = {
    "system/nozbox/wireguard_noah_private_key" = { };
    "system/nozbox/wireguard_noah_preshared_key" = { };
    "system/nozbox/wireguard_jos_private_key" = { };
    "system/nozbox/wireguard_jos_preshared_key" = { };
  };
  networking = {
    nat = {
      enable = true;
      externalInterface = "ens18";
      internalInterfaces = [
        "wg-noah"
        "wg-jos"
      ];
    };
    firewall.allowedUDPPorts = [
      51820
      51821
    ];
    wireguard.interfaces = {
      wg-noah = {
        privateKeyFile = config.sops.secrets."system/nozbox/wireguard_noah_private_key".path;
        ips = [ "10.192.1.254/24" ];
        allowedIPsAsRoutes = false;
        listenPort = 51820;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -o %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ens18 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -o %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ens18 -j MASQUERADE
        '';
        peers = [{
          name = "noah";
          publicKey = "3crOVvn2Zuwb9+2pvLO/pL8dubkmM+BXmllYILGmmjQ=";
          presharedKeyFile = config.sops.secrets."system/nozbox/wireguard_noah_preshared_key".path;
          allowedIPs = [ "10.192.1.0/24" ];
          dynamicEndpointRefreshSeconds = 1800;
          dynamicEndpointRefreshRestartSeconds = 5;
          persistentKeepalive = 1800;
        }];
      };
      wg-jos = {
        privateKeyFile = config.sops.secrets."system/nozbox/wireguard_jos_private_key".path;
        ips = [ "10.192.1.254/24" ];
        allowedIPsAsRoutes = false;
        listenPort = 51821;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -o %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ens18 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -o %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ens18 -j MASQUERADE
        '';
        peers = [{
          name = "jos";
          publicKey = "AiwwJWCUVf/9uK8ryjalYe/zlZeMLla+zuxvMnrWmV4=";
          presharedKeyFile = config.sops.secrets."system/nozbox/wireguard_jos_preshared_key".path;
          allowedIPs = [ "10.192.2.6/24" ];
          dynamicEndpointRefreshSeconds = 1800;
          dynamicEndpointRefreshRestartSeconds = 5;
          persistentKeepalive = 1800;
        }];
      };
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    enableNmbd = false;
    enableWinbindd = false;
    extraConfig = ''
      pam password change = yes
      unix password sync = yes
      read only = no
      force group = users
      force create mode = 755
      force directory mode = 755
    '';
    shares.homes = {
      "path" = "/tank/%S/storage";
      "valid users" = "%S";
      "force user" = "%S";
    };
  };
  environment.shellAliases = {
    passwd = "smbpasswd";
  };

  virtualisation.oci-containers.containers.nginx-proxy-manager = {
    image = "jc21/nginx-proxy-manager";
    environment = {
      TZ = "${config.time.timeZone}";
    };
    volumes = [
      "/tank/root/compose/nginx-proxy-manager/nginx-proxy-manager/data:/data:rw"
      "/tank/root/compose/nginx-proxy-manager/nginx-proxy-manager/letsencrypt:/etc/letsencrypt:rw"
    ];
    ports = [
      "80:80/tcp"
      "443:443/tcp"
      "8181:81/tcp"
    ];
    extraOptions = [
      "--health-cmd=/usr/bin/check-health"
      "--health-interval=10s"
      "--health-timeout=3s"
      "--network-alias=nginx-proxy-manager"
      "--network=bridge"
    ];
  };
  systemd.services.podman-nginx-proxy-manager = {
    partOf = [ "podman-compose-nginx-proxy-manager-root.target" ];
    wantedBy = [ "podman-compose-nginx-proxy-manager-root.target" ];
  };
  virtualisation.oci-containers.containers.fail2ban = {
    image = "crazymax/fail2ban:latest";
    environment = {
      TZ = "${config.time.timeZone}";
      F2B_DB_PURGE_AGE = "180d";
      F2B_LOG_TARGET = "STDOUT";
      F2B_LOG_LEVEL = "INFO";
    };
    volumes = [
      "/tank/root/compose/nginx-proxy-manager/nginx-proxy-manager/data/logs:/var/log:ro"
      "/tank/root/compose/nginx-proxy-manager/fail2ban/data:/data:rw"
    ];
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=NET_RAW"
      "--network=host"
    ];
  };
  systemd.services.podman-fail2ban = {
    partOf = [ "podman-compose-nginx-proxy-manager-root.target" ];
    wantedBy = [ "podman-compose-nginx-proxy-manager-root.target" ];
  };
  systemd.targets.podman-compose-nginx-proxy-manager-root = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation.oci-containers.containers.nginx = {
    image = "nginxinc/nginx-unprivileged";
    environment = {
      TZ = "${config.time.timeZone}";
    };
    volumes = [
      "/tank/root/compose/nginx/nginx/html:/usr/share/nginx/html:ro"
    ];
    ports = [
      "8080:8080/tcp"
    ];
    extraOptions = [
      "--network-alias=nginx"
      "--network=bridge"
    ];
  };
  systemd.services.podman-nginx = {
    partOf = [ "podman-compose-nginx-root.target" ];
    wantedBy = [ "podman-compose-nginx-root.target" ];
  };
  systemd.targets.podman-compose-nginx-root = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation.oci-containers.containers.wordpress = {
    image = "soulteary/sqlite-wordpress";
    environment = {
      TZ = "${config.time.timeZone}";
    };
    volumes = [
      "/tank/root/compose/wordpress/wordpress/html:/var/www/html:rw"
    ];
    ports = [
      "8081:80/tcp"
    ];
    extraOptions = [
      "--network-alias=wordpress"
      "--network=bridge"
    ];
  };
  systemd.services.podman-wordpress = {
    partOf = [ "podman-compose-wordpress-root.target" ];
    wantedBy = [ "podman-compose-wordpress-root.target" ];
  };
  systemd.targets.podman-compose-wordpress-root = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation.oci-containers.containers.syncthing = {
    image = "syncthing/syncthing";
    environment = {
      TZ = "${config.time.timeZone}";
      PUID = "800";
      PGID = "800";
    };
    volumes = [
      "/tank/root/compose/syncthing/syncthing/st-sync:/var/syncthing:rw"
    ];
    ports = [
      "8384:8384/tcp"
      "22000:22000/tcp"
      "22000:22000/udp"
      "21027:21027/udp"
    ];
    extraOptions = [
      "--hostname=nozbox"
      "--network-alias=syncthing"
      "--network=bridge"
    ];
  };
  systemd.services.podman-syncthing = {
    partOf = [ "podman-compose-syncthing-root.target" ];
    wantedBy = [ "podman-compose-syncthing-root.target" ];
  };
  systemd.targets.podman-compose-syncthing-root = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation.oci-containers.containers.baikal = {
    image = "ckulka/baikal:nginx";
    environment = {
      TZ = "${config.time.timeZone}";
    };
    volumes = [
      "/tank/root/compose/baikal/baikal/config:/var/www/baikal/config:rw"
      "/tank/root/compose/baikal/baikal/data:/var/www/baikal/Specific:rw"
    ];
    ports = [
      "5233:80/tcp"
    ];
    extraOptions = [
      "--network-alias=baikal"
      "--network=bridge"
    ];
  };
  systemd.services.podman-baikal = {
    partOf = [ "podman-compose-baikal-root.target" ];
    wantedBy = [ "podman-compose-baikal-root.target" ];
  };
  systemd.targets.podman-compose-baikal-root = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation.oci-containers.containers.minecraft = {
    image = "itzg/minecraft-server";
    environment = {
      TZ = "${config.time.timeZone}";
      EULA = "TRUE";
      VERSION = "1.20.1";
      TYPE = "FABRIC";
      MOTD = "             Nozbox Minecraft Server\\u00A7r\n                 \\u00A78https://nozato.org";
      ICON = "https://community.cloudflare.steamstatic.com/economy/image/i0CoZ81Ui0m-9KwlBY1L_18myuGuq1wfhWSIYhY_9XEDYOMNRBsMoGuuOgceXob50kaxV_PHjMO1MHaEqgQgp9Wnuha1ER70ncflr3oJuauoaqc1c6WWVjHImepw6Lk8F3yywhkj5TuDnN2gbzvJOZSMLUqi";
      OVERRIDE_ICON = "TRUE";
      WHITELIST = ''
        81136bad-e1fe-4bf2-85bc-1d12c18412ae
        00389f64-322b-457b-a20e-f7393b73abbe
      '';
      EXISTING_WHITELIST_FILE = "SYNCHRONIZE";
      OPS = ''
        81136bad-e1fe-4bf2-85bc-1d12c18412ae
      '';
      EXISTING_OPS_FILE = "SYNCHRONIZE";
      VIEW_DISTANCE = "12";
      SIMULATION_DISTANCE = "12";
      ENFORCE_SECURE_PROFILE = "FALSE";
      SNOOPER_ENABLED = "FALSE";
    };
    volumes = [
      "/tank/root/compose/minecraft/minecraft/data:/data:rw"
    ];
    ports = [
      "25565:25565/tcp"
      "25565:25565/udp"
      "24454:24454/udp"
    ];
    extraOptions = [
      "--network-alias=minecraft"
      "--network=bridge"
    ];
  };
  systemd.services.podman-minecraft = {
    partOf = [ "podman-compose-minecraft-root.target" ];
    wantedBy = lib.mkForce [ "podman-compose-minecraft-root.target" ];
  };
  systemd.targets.podman-compose-minecraft-root = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.compose2nix.packages.${system}.default

    ferium
  ];
}
