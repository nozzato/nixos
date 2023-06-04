{ config, lib, pkgs, ... }: {
  users.users.noah = {
    isNormalUser = true;
    description = "Noah Torrance";
    extraGroups = [ "input" "libvirtd" "networkmanager" "wheel" ];
    useDefaultShell = true;
  };
  networking.hostName = "nozzdesk";

  imports = [
    ./bootloader.nix
    ./containerisation.nix
    ./desktop.nix
    ./filesystems.nix
    ./games.nix
    ./geolocation.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./keyring.nix
    ./networking.nix
    ./nodejs.nix
    ./peripherals.nix
    ./sound.nix
    ./thunar.nix
    ./virtualisation.nix
  ];
}