{ config, lib, pkgs, ... }: {
  home.file."${config.xdg.configHome}/libvirt/qemu.conf".text = ''
    nvram = [
      "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd",
      "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"
    ]
  '';
  home.packages = with pkgs; [
    pods
    virt-manager
  ];
}
