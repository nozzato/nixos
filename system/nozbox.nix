{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    inputs.authentik-nix.nixosModules.default
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
      onCalendar = "21:55";
      settings = {
        snapshot_preserve = "7d 4w 12m";
        snapshot_preserve_min = "7d";
        volume."/mnt/tank" = {
          subvolume = {
            containers = { };
            postgresql = { };
            acme = { };
            www = { };
            authentik = { };
            netbird = { };
            nextcloud = { };
            prometheus = { };
            grafana = { };
          };
          snapshot_dir = "/mnt/tank/.btrbk";
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
  };

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

  systemd.services.shutwake = {
    description = "Automatic shutdown and wakeup";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ALARM="09:00 tomorrow"

      echo 0 > /sys/class/rtc/rtc0/wakealarm
      echo $(date -d "$ALARM" +%s) > /sys/class/rtc/rtc0/wakealarm
      echo "Wake alarm set for $ALARM"

      echo "Shutting down..."
      ${pkgs.systemd}/bin/systemctl poweroff
    '';
  };
  systemd.timers.shutwake = {
    description = "Automatic shutdown and wakeup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "shutwake.service";
      OnCalendar = "22:00";
    };
  };

  virtualisation.podman = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "09:35";
    };
  };

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             postgres                                trust
      local   all             all                                     peer
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
  
  security.acme = {
    acceptTerms = true;
    defaults.email = "noahtorrance27@gmail.com";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "nozato.org" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          root = "/srv/www/nozato.org";
          index = "index.html";
        };
      };
      "www.nozato.org" = {
        useACMEHost = "nozato.org";
        forceSSL = true;
        locations."/" = {
          return = "301 https://nozato.org$request_uri";
        };
      };
      "_" = {
        locations."/" = {
          return = 404;
        };
      };
    };
  };

  sops.secrets = {
    "system/nozbox/authentik_environment_file" = { };
  };
  services.authentik = {
    enable = true;
    environmentFile = config.sops.secrets."system/nozbox/authentik_environment_file".path;
    settings = {
      disable_startup_analytics = true;
      avatars = "initials";
    };
    nginx = {
      enable = true;
      enableACME = true;
      host = "auth.nozato.org";
    };
  };

  sops.secrets = {
    "system/nozbox/netbird_datastore_encryption_key" = { };
    "system/nozbox/netbird_idp_management_password" = { };
    "system/nozbox/coturn_password" = {
      owner = "turnserver";
    };
  };
  services.netbird.server = let
    clientId = "aohiGHaUCCRFcmceawE4vJkTGGJ3Uv2ORi0ajeD4";
  in {
    enable = true;
    domain = "netbird.nozato.org";
    management = {
      dnsDomain = "netbird";
      oidcConfigEndpoint = "https://auth.nozato.org/application/o/netbird/.well-known/openid-configuration";
      settings = {
        DataStoreEncryptionKey._secret = config.sops.secrets."system/nozbox/netbird_datastore_encryption_key".path;
        HttpConfig = {
          AuthAudience = clientId;
          AuthIssuer = "https://auth.nozato.org/application/o/netbird/";
          AuthKeysLocation = "https://auth.nozato.org/application/o/netbird/jwks/";
          IdpSignKeyRefreshEnabled = false;
        };
        IdpManagerConfig = {
          ManagerType = "authentik";
          ClientConfig = {
            Issuer = "https://auth.nozato.org/application/o/netbird/";
            TokenEndpoint = "https://auth.nozato.org/application/o/token/";
            ClientID = clientId;
          };
          ExtraConfig = {
            Username = "netbird";
            Password._secret = config.sops.secrets."system/nozbox/netbird_idp_management_password".path;
          };
        };
        DeviceAuthorizationFlow = {
          Provider = "hosted";
          ProviderConfig = {
            ClientID = clientId;
            Domain = "netbird.nozato.org";
            Audience = clientId;
            TokenEndpoint = "https://auth.nozato.org/application/o/token/";
            DeviceAuthEndpoint = "https://auth.nozato.org/application/o/device/";
            Scope = "openid";
          };
        };
        PKCEAuthorizationFlow = {
          ProviderConfig = {
            ClientID = clientId;
            Audience = clientId;
            TokenEndpoint = "https://auth.nozato.org/application/o/token/";
            AuthorizationEndpoint = "https://auth.nozato.org/application/o/authorize/";
            Scope = "openid profile email offline_access api";
          };
        };
        TURNConfig = {
          Secret._secret = config.sops.secrets."system/nozbox/coturn_password".path;
          TimeBasedCredentials = true;
        };
      };
      metricsPort = 9093;
    };
    dashboard.settings = {
      AUTH_AUTHORITY = "https://auth.nozato.org/application/o/netbird";
      AUTH_CLIENT_ID = clientId;
      AUTH_SUPPORTED_SCOPES = "openid profile email offline_access api";
    };
    signal.metricsPort = 9092;
    enableNginx = true;
    coturn = {
      enable = true;
      useAcmeCertificates = true;
      passwordFile = config.sops.secrets."system/nozbox/coturn_password".path;
    };
  };
  services.nginx.virtualHosts.${config.services.netbird.server.domain} = {
    enableACME = true;
    forceSSL = true;
  };
  systemd.services.netbird-management = {
    requires = [ "authentik.service" ];
    after = [ "authentik.service" ];
    preStart = ''
      # Wait until Authentik is online
      sleep 30
    '';
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    datadir = "/mnt/tank/nextcloud";
    hostName = "nextcloud.nozato.org";
    https = true;
    database.createLocally = true;
    configureRedis = true;
    caching.redis = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = toString (pkgs.writeText "nextcloud_adminpass" "PWD");
    };
    settings = {
      opcache.enable = 1;
      opcache.validate_timestamps = 0;
      opcache.interned_strings_buffer = 16;
      default_phone_region = "GB";
      mail_smtpmode = "null";
    };
  };
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
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
        root_url = "https://grafana.nozato.org";
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
  services.nginx.virtualHosts."grafana.nozato.org" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };

  systemd.services.backup-application-data = {
    description = "Backup application data";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/containers/storage/volumes/ /mnt/tank/containers/storage/volumes/

      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/postgresql/ /mnt/tank/postgresql/

      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/acme/ /mnt/tank/acme/

      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /srv/www/ /mnt/tank/www/

      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/authentik/media/ /mnt/tank/authentik/authentik/media/
      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/redis-authentik/ /mnt/tank/authentik/redis-authentik/

      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/netbird-mgmt/ /mnt/tank/netbird/

      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/nextcloud/store-apps/ /mnt/tank/nextcloud/store-apps/

      ${pkgs.rsync}/bin/rsync -av --mkpath --delete /var/lib/grafana/data/grafana.db /mnt/tank/grafana/data/grafana.db
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

  networking.firewall = {
    allowedTCPPorts = [
      # WWW
      80
      443
    ];
  };
}
