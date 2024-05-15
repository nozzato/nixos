{ inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

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

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/eddee7b4-dad5-48e6-a427-ee7017524dcf";
    fsType = "ext4";
  };

  networking = {
    hostName = "nozbox";
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
  };

  services.qemuGuest.enable = true;
}
