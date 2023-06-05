{ config, lib, pkgs, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };

  environment.systemPackages = with pkgs; [
    hip
  ];
  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.hip}"
  ];
}