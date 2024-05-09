{
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16384;
  }];
}
