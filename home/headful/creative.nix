{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    audacity
    gimp
    godot
    inkscape
    kdenlive
    krita
    libreoffice-fresh
    pinta
    rawtherapee
  ];
}
