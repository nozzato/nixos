{ config, lib, pkgs, ... }: {
  imports = [
    ./containerisation.nix
    ./desktop.nix
    ./games.nix
    ./geolocation.nix
    ./keyring.nix
    ./nodejs.nix
    ./sound.nix
    ./thunar.nix
    ./virtualisation.nix
  ];
}