{ lib, config, pkgs, ... }: {
  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
  };

  fileSystems = {
    "/media/windows" = {
      label = "windows";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=100" "dmask=022" "fmask=133" ];
    };
    "/media/share" = {
      label = "share";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=100" "dmask=022" "fmask=033" ];
    };
    "/media/linux-share" = {
      label = "linux-share";
      fsType = "ext4";
    };
  };

  services.syncthing = {
    enable = true;
    user = "noah";
    dataDir = "/home/noah/Sync";
    configDir = "/home/noah/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      options = {
        urAccepted = -1;
      };
      devices = {
        "nozbox" = { id = "BVC35LK-YROXVMS-SMWLNUS-DYKEFWM-ADO4TKJ-5JYHHIR-LLOAW72-BOLYZAR"; };
      };
      folders = {
        "nozbox-noah" = {
          path = "~/Sync/nozbox";
          devices = [ "nozbox" ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "2592000";
            };
          };
        };
      };
    };
  };

  sops.secrets = {
    "system/client/smb_nozbox_noah_credentials" = { };
  };
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];
  systemd.mounts = [{
    description = "Nozbox Samba mount";
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    what = "//nozbox/noah";
    where = "/media/nozbox";
    type = "cifs";
    options = lib.concatStringsSep "," [
      "_netdev"
      "credentials=${config.sops.secrets."system/client/smb_nozbox_noah_credentials".path}"
      "uid=${toString config.users.users.noah.uid}"
      "gid=100"
    ];
  }];
  systemd.automounts = [{
    description = "Nozbox Samba mount";
    wantedBy = [ "multi-user.target" ];
    where = "/media/nozbox";
    automountConfig = {
      JobTimeoutSec = "5";
      TimeoutSec = "5";
      TimeoutIdleSec = "60";
    };
  }];

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
  };
  system.activationScripts.makeSddmKcminputrc = lib.stringAfter [ "var" ] ''
    mkdir -p /var/lib/sddm/.config
    cat << EOF > /var/lib/sddm/.config/kcminputrc
    [Keyboard]
    NumLock=0

    [Libinput][1241][41119][E-Signal USB Gaming Mouse]
    PointerAcceleration=0.2
    PointerAccelerationProfile=1

    [Mouse]
    X11LibInputXAccelProfileFlat=true
    EOF
  '';
  services.desktopManager.plasma6.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gpm.enable = true;
  hardware.bluetooth.enable = true;
  hardware.xone.enable = true;
  programs.adb.enable = true;
  programs.kdeconnect.enable = true;

  programs.partition-manager.enable = true;

  services.printing.enable = true;

  location.provider = "geoclue2";

  programs.steam = {
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      # Calibre
      9090
    ];
  };
}
