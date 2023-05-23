{ config, lib, pkgs, stylix, ... }:

{
  imports = [
    ./desktop.nix
    ./packages.nix
    #./stylix.nix
  ];
}
