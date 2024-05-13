{ lib, ... }: {
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

  fileSystems = {
    "/media/nozbox" = {
      device = "//192.168.1.6/noah";
      fsType = "cifs";
      options = [ "x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/etc/nixos/smb-nozbox-secrets,uid=1000,gid=100,dir_mode=0700,file_mode=0600" ];
    };
  };

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

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  programs.adb.enable = true;
  programs.kdeconnect.enable = true;

  programs.ssh.startAgent = true;

  programs.partition-manager.enable = true;

  services.printing.enable = true;

  location.provider = "geoclue2";

  programs.steam = {
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };
}
