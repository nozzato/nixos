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
    protontricks
    soundOfSorting
    space-cadet-pinball
  ];
}
