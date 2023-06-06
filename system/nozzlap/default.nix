{ config, lib, pkgs, ... }: {
  users.users.noah = {
    isNormalUser = true;
    description = "Noah Torrance";
    extraGroups = [ "input" "libvirtd" "networkmanager" "wheel" ];
    useDefaultShell = true;
  };
  networking.hostName = "nozzlap";

  imports = [
    ./filesystems.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./peripherals.nix
    ./timers.nix
  ];
}
