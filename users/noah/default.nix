{ config, lib, pkgs, stylix, ... }: {
  imports = [
    ./desktop.nix
    ./music.nix
    ./packages.nix
    ./shell.nix
    ./theme.nix
    ./xdg.nix
  ];
}
