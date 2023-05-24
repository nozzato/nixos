{ config, lib, pkgs, stylix, ... }:

{
  imports = [
    ./desktop.nix
    ./packages.nix
    ./shell.nix
    ./stylix.nix
  ];
}
