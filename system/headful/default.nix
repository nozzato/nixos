{ config, lib, pkgs, ... }: {
  imports = [
    ./desktop.nix
    ./games.nix
    ./geolocation.nix
    ./keyring.nix
    ./printing.nix
    ./sound.nix
    ./thunar.nix
    ./virtualisation.nix
  ];
}
