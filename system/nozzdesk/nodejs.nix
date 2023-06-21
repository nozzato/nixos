{ config, lib, pkgs, ... }: {
  programs.npm.enable = true;
  environment.systemPackages = with pkgs; [
    nodejs
  ];
}