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

  sops.secrets = {
    "system/client/nextcloud_mount_credentials" = { };
  };
  services.davfs2 = {
    enable = true;
    settings.globalSection = {
      use_locks = false;
      gui_optimize = true;
    };
  };
  environment.etc."davfs2/secrets".source = config.sops.secrets."system/client/nextcloud_mount_credentials".path;
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
    "/media/nextcloud" = {
      device = "https://nextcloud.nozato.org/remote.php/dav/files/cd991fed9c087159f639908ab7be4fa23e67cfba4e4c49abd431725da7b93c46";
      fsType = "davfs";
      options = [ "uid=1000" "gid=1000" "_netdev" "auto" ];
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
