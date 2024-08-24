{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  system.autoUpgrade = {
    allowReboot = true;
    rebootWindow = {
      lower = "04:40";
      upper = "05:40";
    };
  };
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
    fileSystems = [ "/mnt/tank" ];
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
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "podman";
  systemd.timers."podman-auto-update".wantedBy = [ "timers.target" ];

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
  systemd.services."ilo-connect" = {
    description = "Establish SSH connection to iLO";
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # https://github.com/kendallgoto/ilo4_unlock/blob/main/scripts/ja-silence-dl20G9.sh

      IP=192.168.1.4
      SCREEN_NAME="ilo"

      echo "Creating screen session"
      IP=''${IP} ${pkgs.screen}/bin/screen -dmS $SCREEN_NAME

      echo "Establishing SSH connection to iLO"
      while true; do
        echo "Checking if iLO is up"
        set +e
        ${pkgs.iputils}/bin/ping -q -c 1 ''${IP} &>/dev/null
        if [ $? -ne 0 ]; then
          echo "iLO not responding. Reattempting in 30 seconds";
        else
          set -e
          break
        fi
        sleep 30
      done

      ${pkgs.screen}/bin/screen -S $SCREEN_NAME -X stuff "${pkgs.sshpass}/bin/sshpass -p $(cat ${config.sops.secrets."system/nozbox/ilo_password".path}) ${pkgs.openssh}/bin/ssh Administrator@192.168.1.4 -o LocalCommand='fan info'"`echo -ne '\015'`
      sleep 5

      echo "Applying custom settings"

      # Set CPU fan offset
      ${pkgs.screen}/bin/screen -S $SCREEN_NAME -X stuff 'fan t 1 adj 33'`echo -ne '\015'`
      ${pkgs.screen}/bin/screen -S $SCREEN_NAME -X stuff 'fan t 1 caut 20'`echo -ne '\015'`

      # Set CPU PID algorithm
      ${pkgs.screen}/bin/screen -S $SCREEN_NAME -X stuff 'fan pid 1 p 350'`echo -ne '\015'`
      ${pkgs.screen}/bin/screen -S $SCREEN_NAME -X stuff 'fan pid 1 hi 23000'`echo -ne '\015'`
    '';
    preStop = ''
      SCREEN_NAME="ilo"

      ${pkgs.screen}/bin/screen -S $SCREEN_NAME -X quit
      ${pkgs.screen}/bin/screen -wipe
    '';
  };
  systemd.services."ilo-adjust" = {
    description = "Adjust iLO fan speed";
    requires = [ "ilo-connect.service" ];
    after = [ "ilo-connect.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      # https://github.com/kendallgoto/ilo4_unlock/blob/main/scripts/cf-dynamic-fans.sh

      SCREEN_NAME="ilo"
      MIN_TEMP=45
      MAX_TEMP=90
      MIN_SPEED=40
      MAX_SPEED=230
      TEMP_RANGE=$((MAX_TEMP - MIN_TEMP))
      SPEED_RANGE=$((MAX_SPEED - MIN_SPEED))

      adjust_fan_speed() {
        local TEMPERATURE=$1
        local FAN_GROUP=$2
        local SPEED

        if [ "$TEMPERATURE" -le $MIN_TEMP ]; then
          SPEED=$MIN_SPEED
        elif [ "$TEMPERATURE" -ge $MAX_TEMP ]; then
          SPEED=$MAX_SPEED
        else
          # Calculate speed based on the temperature
          SPEED=$(($MIN_SPEED + ($TEMPERATURE - $MIN_TEMP) * $SPEED_RANGE / $TEMP_RANGE))
        fi

        # Apply the calculated speed to each fan in the group
        for FAN in $FAN_GROUP; do
          ${pkgs.screen}/bin/screen -S $SCREEN_NAME -X stuff "fan p $FAN max $SPEED"`echo -ne '\015'`
        done
        echo "Fan speed: $SPEED"
      }

      # Define fan groups based on fan configuration
      FAN_GROUP="0"

      while true; do
        # Get average CPU temperature from sensors
        CPU_TEMP=$(${pkgs.lm_sensors}/bin/sensors coretemp-isa-0000 | ${pkgs.gawk}/bin/awk '/^Core /{++r; gsub(/[^[:digit:]]+/, "", $3); s+=$3} END{print s/(10*r)}')
        echo "CPU temperature: $CPU_TEMP°C"

        # Adjust fan speeds based on the temperature
        adjust_fan_speed "''${CPU_TEMP%.*}" "$FAN_GROUP"
        sleep 10
      done
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
      OnCalendar = "*:0/30";
      Unit = "ddns-client.service";
    };
  };

  virtualisation.oci-containers.containers.syncthing = {
    image = "docker.io/syncthing/syncthing";
    environment = {
      TZ = "${config.time.timeZone}";
      PUID = "800";
      PGID = "800";
    };
    volumes = [
      "/mnt/tank/root/compose/syncthing/syncthing/st-sync:/var/syncthing:rw"
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
    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
  systemd.services.podman-syncthing = {
    description = "Syncthing Podman container";
    partOf = [ "podman-compose-syncthing-root.target" ];
    wantedBy = [ "podman-compose-syncthing-root.target" ];
  };
  systemd.targets.podman-compose-syncthing-root = {
    description = "Root target generated by compose2nix";
    wantedBy = [ "multi-user.target" ];
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
      "path" = "/mnt/tank/%S/storage";
      "valid users" = "%S";
      "force user" = "%S";
    };
  };
  environment.shellAliases = {
    passwd = "smbpasswd";
  };

  virtualisation.oci-containers.containers.baikal = {
    image = "docker.io/ckulka/baikal:nginx";
    environment = {
      TZ = "${config.time.timeZone}";
    };
    volumes = [
      "/mnt/tank/root/compose/baikal/baikal/config:/var/www/baikal/config:rw"
      "/mnt/tank/root/compose/baikal/baikal/data:/var/www/baikal/Specific:rw"
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
    description = "Baikal Podman container";
    partOf = [ "podman-compose-baikal-root.target" ];
    wantedBy = [ "podman-compose-baikal-root.target" ];
  };
  systemd.targets.podman-compose-baikal-root = {
    description = "Root target generated by compose2nix";
    wantedBy = [ "multi-user.target" ];
  };

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
          root * /mnt/tank/caddy
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
          reverse_proxy /admin* localhost:8181
          reverse_proxy localhost:8080
        '';
      };
    };
  };

  services.headscale = {
    enable = true;
    address = "0.0.0.0";
  };
  systemd.services.headscale = {
    serviceConfig = {
      TimeoutStopSec = 5;
    };
  };
  virtualisation.oci-containers.containers.headscale-admin = {
    image = "docker.io/goodieshq/headscale-admin";
    environment = {
      TZ = "${config.time.timeZone}";
    };
    volumes = [
      "/mnt/tank/root/compose/syncthing/syncthing/st-sync:/var/syncthing:rw"
    ];
    ports = [
      "8181:80/tcp"
    ];
    extraOptions = [
      "--hostname=nozbox"
      "--network-alias=headscale-admin"
      "--network=bridge"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
  systemd.services.podman-headscale-admin = {
    description = "Headscale-Admin Podman container";
    partOf = [ "podman-compose-headscale-admin-root.target" ];
    wantedBy = [ "podman-compose-headscale-admin-root.target" ];
  };
  systemd.targets.podman-compose-headscale-admin-root = {
    description = "Root target generated by compose2nix";
    wantedBy = [ "multi-user.target" ];
  };

  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-exit-node"
      "--accept-dns=false"
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
      TZ = "${config.time.timeZone}";
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
      "/mnt/tank/root/compose/minecraft/minecraft/data:/data:rw"
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
    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
  systemd.services.podman-minecraft = {
    description = "Minecraft server Podman container";
    partOf = [ "podman-compose-minecraft-root.target" ];
    wantedBy = lib.mkForce [ "podman-compose-minecraft-root.target" ];
  };
  systemd.targets.podman-compose-minecraft-root = {
    description = "Root target generated by compose2nix";
  };

  /*services.prometheus = {
    enable = true;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
    };
    scrapeConfigs = [
      {
        job_name = "${config.networking.hostName}";
        static_configs = [{
          targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
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
        }
      ];
    };
  };*/

  environment.systemPackages = with pkgs; [
    # Minecraft server
    ferium
  ];

  networking.firewall = {
    allowedTCPPorts = [
      # ntfy
      2586

      # Caddy
      80
      443

      # Grafana
      #3000
    ];
  };
}
