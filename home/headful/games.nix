{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    asciiquarium
    cowsay
    heroic
    linuxwave
    nyancat
    osu-lazer-bin
    prismlauncher
    protontricks
    protonup-qt
    soundOfSorting
    space-cadet-pinball
  ];
}
