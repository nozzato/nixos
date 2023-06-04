{ config, lib, pkgs, ... }: {
  services.easyeffects.enable = true;

  home.packages = with pkgs; [
    helvum
    pamixer
    pavucontrol
  ];
}