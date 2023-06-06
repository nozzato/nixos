{ config, lib, pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.waydroid.enable = true;
  virtualisation.lxd.enable = true;
}