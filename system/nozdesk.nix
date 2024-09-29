{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    initrd.availableKernelModules = [
      "nvme"
      "ahci"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [
      "kvm-amd"
      "v4l2loopback"
      "snd-aloop"
    ];
    extraModprobeConfig = ''
      options v4l2loopback card_label="Virtual Camera" devices=1 exclusive_caps=1
    '';
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16384;
  }];
  boot = {
    resumeDevice = "/dev/disk/by-uuid/3b21e3fd-3592-4940-8c9d-ecdff615390a";
    kernelParams = [ "resume_offset=54583296" ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3b21e3fd-3592-4940-8c9d-ecdff615390a";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/EED5-835D";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  networking = {
    hostName = "nozdesk";
    useDHCP = false;
    interfaces = {
      "enp39s0" = {
        ipv4.addresses = [{
          address = "192.168.1.3";
          prefixLength = 24;
        }];
      };
    };
    enableIPv6 = false;
    defaultGateway = "192.168.1.254";
    nameservers = [ "192.168.1.254" ];
  };

  systemd.services.tailscaled-autoconnect = {
    preStart = ''
      ${pkgs.ethtool}/bin/ethtool -K enp39s0 rx-udp-gro-forwarding on rx-gro-list off
    '';
  };

  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [
    ddcutil
  ];

  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  systemd.nspawn.archlinux = {
    filesConfig = {
      Bind = [
        "/dev/dri"
        "/dev/kfd"
        "/dev/snd"
        "/dev/video0"
        "/run/user/${toString config.users.users.noah.uid}:/mnt/run"
      ];
      TemporaryFileSystem = "/tmp:size=100%";
    };
    execConfig = {
      PrivateUsers = false;
    };
    networkConfig = {
      Private = false;
    };
  };
  system.activationScripts.deviceAllowArchlinux = lib.stringAfter [ "var" ] ''
    ${pkgs.systemd}/bin/systemctl set-property systemd-nspawn@archlinux.service \
      DeviceAllow=/dev/dri/renderD128 \
      DeviceAllow=/dev/kfd
      DeviceAllow=/dev/video0
  '';
  system.activationScripts.linkArchlinux = lib.stringAfter [ "var" ] ''
    ln -sf ${config.users.users.noah.home}/machines/archlinux /var/lib/machines/archlinux
  '';

  systemd.nspawn.active-archlinux = {
    filesConfig = {
      Bind = [
        "/dev/dri"
        "/dev/kfd"
        "/dev/snd"
        "/dev/video0"
        "/run/user/${toString config.users.users.noah.uid}:/mnt/run"
      ];
      TemporaryFileSystem = "/tmp:size=100%";
    };
    execConfig = {
      PrivateUsers = false;
    };
    networkConfig = {
      Private = false;
    };
  };
  system.activationScripts.deviceAllowActiveArchlinux = lib.stringAfter [ "var" ] ''
    ${pkgs.systemd}/bin/systemctl set-property systemd-nspawn@active-archlinux.service \
      DeviceAllow=/dev/dri/renderD128 \
      DeviceAllow=/dev/kfd
      DeviceAllow=/dev/video0
  '';
  system.activationScripts.linkActiveArchlinux = lib.stringAfter [ "var" ] ''
    ln -sf /media/linux-active/machines/active-archlinux /var/lib/machines/active-archlinux
  '';
}
