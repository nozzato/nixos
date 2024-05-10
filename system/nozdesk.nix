{ inputs, lib, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
  };
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16384;
  }];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/68853943-689a-48a8-b912-9f3f45ed6e15";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/68A8-95CB";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

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

  systemd.nspawn.active-archlinux = {
    filesConfig = {
      Bind = [
        "/dev/dri"
        "/dev/kfd"
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
  system.activationScripts.linkActiveArchlinux = lib.stringAfter [ "var" ] ''
    ln -fs /media/active-linux/machines/active-archlinux /var/lib/machines/active-archlinux
  '';
}
