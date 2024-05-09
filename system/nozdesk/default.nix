{ ... }: {
  imports = [
    ./nix.nix
    ./hardware.nix
    ./bootloader.nix
    ./filesystems.nix
    ./networking.nix
    ./systemd-nspawn.nix
  ];
}
