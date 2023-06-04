{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    heroic
    bsdgames
    osu-lazer-bin
    prismlauncher
    space-cadet-pinball
  ];
}