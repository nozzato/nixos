{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    asciiquarium
    bsdgames
    cowsay
    heroic
    linuxwave
    nyancat
    osu-lazer-bin
    prismlauncher
    soundOfSorting
    space-cadet-pinball
  ];
}