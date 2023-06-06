{ config, lib, pkgs, ... }: {
  users.users.noah = {
    isNormalUser = true;
    description = "Noah Torrance";
    extraGroups = [ "input" "libvirtd" "networkmanager" "wheel" ];
    useDefaultShell = true;
  };
  networking.hostName = "nozzdesk";

  imports = [
    ./filesystems.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    ./printing.nix
  ];
}
