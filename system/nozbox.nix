{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    inputs.vpn-confinement.nixosModules.default
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = [
      "ehci_pci"
      "ahci"
      "uhci_hcd"
      "xhci_pci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "sr_mod"
    ];
    kernelModules = [
      "kvm-intel"
    ];
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16384;
  }];

  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_08606E6B64C4BD80633D12BC-0:0";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/de38ad21-d1ab-4a8d-b4f4-1c89eaad3b1c";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/22B3-F485";
      fsType = "vfat";
    };
    "/mnt/tank" = {
      device = "/dev/disk/by-uuid/16ba5eec-16da-46a4-a800-eeabbba0e18e";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };
  };

  boot.supportedFilesystems = [ "btrfs" ];
  services.btrfs.autoScrub = {
    enable = true;
    interval = "*-*-01 09:05";
    fileSystems = [ "/mnt/tank" ];
  };
  services.btrbk = {
    instances.tank = {
      onCalendar = "23:55";
      settings = {
        snapshot_preserve = "7d 4w 12m";
        snapshot_preserve_min = "7d";
        volume."/mnt/tank" = {
          subvolume = {
            data = { };
            noah = { };
            jodie = { };
            bella = { };
            jos = { };
          };
          snapshot_dir = "/mnt/tank/.btrfs/snapshots";
        };
      };
    };
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
    ln -snf /mnt/tank/jodie /home/jodie
    ln -snf /mnt/tank/bella /home/bella
    ln -snf /mnt/tank/jos /home/jos
  '';

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune = {
      enable = true;
      dates = "09:35";
    };
  };
  virtualisation.oci-containers.backend = "podman";

  networking = {
    hostName = "nozbox";
    useDHCP = false;
    interfaces = {
      "eno1" = {
        ipv4.addresses = [{
          address = "192.168.1.5";
          prefixLength = 24;
        }];
      };
    };
    enableIPv6 = false;
    defaultGateway = "192.168.1.254";
    nameservers = [ "192.168.1.254" ];
  };

  sops.secrets = {
    "system/nozbox/ilo_password" = { };
  };
  systemd.services."ilo-fan" = {
    description = "Adjust iLO fan curve";
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Wait until iLO is online
      until ${pkgs.iputils}/bin/ping -c 1 -q nozbox-ilo &> /dev/null; do
        sleep 30
      done

      # Start screen session
      ${pkgs.screen}/bin/screen -dmS ilo

      # SSH into iLO
      ${pkgs.screen}/bin/screen -S ilo -X stuff "${pkgs.sshpass}/bin/sshpass -p $(cat ${config.sops.secrets."system/nozbox/ilo_password".path}) ${pkgs.openssh}/bin/ssh Administrator@nozbox-ilo -o LocalCommand='fan info'"`echo -ne '\015'`
      sleep 5

      # Adjust fan curve
      ${pkgs.screen}/bin/screen -S ilo -X stuff 'fan t 0 adj -14'`echo -ne '\015'`  # Offset sensor 0
      ${pkgs.screen}/bin/screen -S ilo -X stuff 'fan pid 0 p 51216'`echo -ne '\015'`  # Set PWM range to 16 <--> 200 ((200 * 256) + 16)

      ${pkgs.screen}/bin/screen -S ilo -X stuff 'fan t 1 adj 35'`echo -ne '\015'`  # Offset sensor 1
      ${pkgs.screen}/bin/screen -S ilo -X stuff 'fan t 1 caut 30'`echo -ne '\015'`  # Set caution (shutdown) threshold to 100°C
    '';
  };


  sops.secrets = {
    "system/nozbox/ddns_password" = { };
  };
  systemd.services.ddns-client = {
    description = "Dynamic DNS client";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.curl}/bin/curl "https://dynamicdns.park-your-domain.com/update?host=@&domain=nozato.org&password=$(cat ${config.sops.secrets."system/nozbox/ddns_password".path})"
    '';
  };
  systemd.timers.ddns-client = {
    description = "Dynamic DNS client";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "ddns-client.service";
      OnCalendar = "*:0/30";
    };
  };

  sops.secrets = {
    "system/nozbox/wireguard_config" = { };
  };
  vpnNamespaces = {
    funzbra = {
      enable = true;
      wireguardConfigFile = config.sops.secrets."system/nozbox/wireguard_config".path;
      accessibleFrom = [
        "100.64.0.0/24"
      ];
      portMappings = [
        # Transmission
        { from = 9091; to = 9091; protocol = "tcp"; }
      ];
      openVPNPorts = [
        # Transmission
        { port = 51413; protocol = "both"; }
      ];
    };
  };

  virtualisation.oci-containers.containers.syncthing = {
    image = "docker.io/syncthing/syncthing";
    environment = {
      PUID = toString config.users.users.noah.uid;
      PGID = toString config.users.groups.${config.users.users.noah.group}.gid;
    };
    volumes = [
      "syncthing_syncthing_data:/var/syncthing"
    ];
    ports = [
      "8384:8384/tcp"
      "22000:22000/tcp"
      "22000:22000/udp"
      "21027:21027/udp"
    ];
    extraOptions = [
      "--hostname=nozbox"
      "--network=bridge"
    ];
  };
  systemd.services.podman-syncthing = {
    description = "Syncthing Podman container";
    partOf = [ "podman-compose-syncthing-root.target" ];
    wantedBy = [ "podman-compose-syncthing-root.target" ];
  };
  systemd.targets.podman-compose-syncthing-root = {
    description = "Root target for Syncthing Podman container";
    wantedBy = [ "multi-user.target" ];
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    nmbd.enable = false;
    winbindd.enable = false;
    settings = {
      "global" = {
        "pam password change" = "yes";
        "unix password sync" = "yes";
        "read only" = "no";
        "force group" = "users";
        "force create mode" = "755";
        "force directory mode" = "755";
        "name resolve order" = "host lmhosts wins bcast";
      };
      "homes" = {
        "path" = "/mnt/tank/%S/storage";
        "valid users" = "%S";
        "force user" = "%S";
      };
    };
  };
  environment.shellAliases = {
    passwd = "smbpasswd";
  };

  sops.secrets = {
    "system/nozbox/torrents_crypt_password" = { };
  };
  systemd.services.mount-torrents = {
    description = "Torrents gocryptfs mount";
    after = [ "local-fs.target" ];
    before = [ "transmission.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      ${pkgs.gocryptfs}/bin/gocryptfs \
        --extpass="cat ${config.sops.secrets."system/nozbox/torrents_crypt_password".path}" \
        /mnt/tank/data/torrents.crypt \
        /mnt/tank/data/torrents \
        -allow_other
    '';
    preStop = ''
      ${pkgs.fuse}/bin/fusermount -u /mnt/tank/data/torrents
    '';
  };

  virtualisation.oci-containers.containers.baikal = {
    image = "docker.io/ckulka/baikal:nginx";
    volumes = [
      "baikal_baikal_config:/var/www/baikal/config"
      "baikal_baikal_db:/var/www/baikal/Specific"
    ];
    ports = [
      "5233:80/tcp"
    ];
    extraOptions = [
      "--network=bridge"
    ];
  };
  systemd.services.podman-baikal = {
    description = "Baikal Podman container";
    partOf = [ "podman-compose-baikal-root.target" ];
    wantedBy = [ "podman-compose-baikal-root.target" ];
  };
  systemd.targets.podman-compose-baikal-root = {
    description = "Root target for Baikal Podman container";
    wantedBy = [ "multi-user.target" ];
  };

  sops.secrets = {
    "system/nozbox/transmission_credentials" = {
      owner = config.services.transmission.user;
    };
  };
  services.transmission = {
    enable = true;
    group = "noah";
    webHome = pkgs.flood-for-transmission;
    credentialsFile = config.sops.secrets."system/nozbox/transmission_credentials".path;
    settings = {
      download-dir = "/mnt/tank/data/torrents/Downloads";
      incomplete-dir = "/mnt/tank/data/torrents/.incomplete";
      rpc-bind-address = "192.168.15.1";
      rpc-whitelist-enabled = false;
      rpc-authentication-required = true;
    };
  };
  systemd.services.transmission = {
    requires = [ "mount-torrents.service" ];
    after = [ "mount-torrents.service" ];
    vpnConfinement = {
      enable = true;
      vpnNamespace = "funzbra";
    };
  };

  /*services.jellyfin = {
    enable = true;
    group = "noah";
  };
  systemd.services.jellyfin = {
    requires = [ "mount-torrents.service" ];
    after = [ "mount-torrents.service" ];
  };*/

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "http://0.0.0.0";
      listen-http = ":2586";
    };
  };
  
  services.caddy = {
    enable = true;
    virtualHosts = {
      "nozato.org" = {
        extraConfig = ''
          root * /var/lib/caddy/web
          encode zstd gzip
          file_server
        '';
      };
      "www.nozato.org" = {
        extraConfig = ''
          redir https://nozato.org{uri}
        '';
      };
      "net.nozato.org" = {
        extraConfig = '' 
          reverse_proxy /admin/* localhost:8181
          reverse_proxy localhost:8080
        '';
      };
    };
  };

  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    settings.dns.base_domain = config.networking.hostName;
  };
  systemd.services.headscale = {
    serviceConfig = {
      TimeoutStopSec = 5;
    };
  };
  virtualisation.oci-containers.containers.headscale-admin = {
    image = "docker.io/goodieshq/headscale-admin";
    ports = [
      "8181:80/tcp"
    ];
    extraOptions = [
      "--hostname=nozbox"
      "--network=bridge"
    ];
  };
  systemd.services.podman-headscale-admin = {
    description = "Headscale-Admin Podman container";
    partOf = [ "podman-compose-headscale-admin-root.target" ];
    wantedBy = [ "podman-compose-headscale-admin-root.target" ];
  };
  systemd.targets.podman-compose-headscale-admin-root = {
    description = "Root target for Headscale-Admin Podman container";
    wantedBy = [ "multi-user.target" ];
  };

  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--login-server=http://localhost:8080"
      "--reset"
    ];
  };
  systemd.services.tailscaled-autoconnect = {
    preStart = ''
      ${pkgs.ethtool}/bin/ethtool -K eno1 rx-udp-gro-forwarding on rx-gro-list off
    '';
  };

  virtualisation.oci-containers.containers.minecraft = {
    image = "docker.io/itzg/minecraft-server";
    environment = {
      EULA = "TRUE";
      VERSION = "1.20.1";
      TYPE = "FABRIC";
      MOTD = "             Nozbox Minecraft Server\\u00A7r\n                    \\u00A78mc.nozato.org";
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
      "minecraft_minecraft_data:/data"
    ];
    ports = [
      "25565:25565/tcp"
      "25565:25565/udp"
      "24454:24454/udp"
    ];
    extraOptions = [
      "--network=bridge"
    ];
  };
  systemd.services.podman-minecraft = {
    description = "Minecraft server Podman container";
    partOf = [ "podman-compose-minecraft-root.target" ];
    wantedBy = lib.mkForce [ "podman-compose-minecraft-root.target" ];
  };
  systemd.targets.podman-compose-minecraft-root = {
    description = "Root target for Minecraft server Podman container";
  };

  services.prometheus = {
    enable = true;
    globalConfig = {
      scrape_interval = "10s";
    };
    scrapeConfigs = [
      {
        job_name = "glances";
        static_configs = [{
          targets = [
            "nozdesk-linux:9091"
            "localhost:9091"
          ];
        }];
      }
    ];
  };
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        root_url = "http://nozbox:3000";
      };
      analytics = {
        reporting_enabled = false;
      };
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://localhost:${toString config.services.prometheus.port}";
          jsonData = {
            timeInterval = "10s";
          };
        }
      ];
    };
  };
  virtualisation.oci-containers.containers.grafana-to-ntfy = {
    image = "docker.io/saibe1111/grafana-to-ntfy";
    environment = {
      NTFY_SERVER = "http://localhost:2586";
      NTFY_TOPIC = "nozato";
    };
    extraOptions = [
      "--network=host"
    ];
  };
  systemd.services.podman-grafana-to-ntfy = {
    description = "Grafana-to-ntfy Podman container";
    partOf = [ "podman-compose-grafana-to-ntfy-root.target" ];
    wantedBy = [ "podman-compose-grafana-to-ntfy-root.target" ];
  };
  systemd.targets.podman-compose-grafana-to-ntfy-root = {
    description = "Root target for Grafana-to-ntfy Podman container";
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.backup-application-data = {
    description = "Backup application data";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/caddy/web/ /mnt/tank/data/root/var/lib/caddy/web/
      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/containers/storage/volumes/ /mnt/tank/data/root/var/lib/containers/storage/volumes/
      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/grafana/data/grafana.db /mnt/tank/data/root/var/lib/grafana/data/grafana.db
      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/headscale/ /mnt/tank/data/root/var/lib/headscale/
      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/prometheus2/data/ /mnt/tank/data/root/var/lib/prometheus2/data/
    '';
  };
  systemd.timers.backup-application-data = {
    description = "Backup application data";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "backup-application-data.service";
      OnCalendar = "21:50";
    };
  };

  environment.systemPackages = with pkgs; [
    # Minecraft server
    ferium
  ];

  networking.firewall = {
    allowedTCPPorts = [
      # Caddy
      80
      443

      # Headscale
      8080
    ];
    allowedUDPPorts = [
      # WireGuard
      51820
    ];
  };
}
