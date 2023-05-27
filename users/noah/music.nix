{ config, lib, pkgs, ... }:

{
  programs.beets = {
    enable = true;
    settings = builtins.readFile ./beets/config.yaml + ''
      directory: ${config.xdg.userDirs.music}/music
      library: ${config.xdg.userDirs.music}/music/library.db
    '';
  };
  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.music}/music";
    extraConfig = builtins.readFile ./mpd/mpd.conf;
  };
  services.mpd-mpris = {
    enable = true;
  };
  programs.ncmpcpp = {
    enable = true;
  };
  services.playerctld = {
    enable = true;
  };
}