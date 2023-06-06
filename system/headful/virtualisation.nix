{ config, lib, pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };
  virtualisation.spiceUSBRedirection.enable = true;
  users.users.noah = {
    extraGroups = [ "libvirtd" ];
  };
}
