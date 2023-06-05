{ config, lib, pkgs, ... }: {
  imports = [
    ./bootloader.nix
    ./containerisation.nix
    ./desktop.nix
    ./games.nix
    ./geolocation.nix
    ./keyring.nix
    ./networking.nix
    ./nodejs.nix
    ./sound.nix
    ./thunar.nix
    ./virtualisation.nix
  ];
}