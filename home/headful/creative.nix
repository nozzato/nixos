{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    audacity
    blender-hip
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