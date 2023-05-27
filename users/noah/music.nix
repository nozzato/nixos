{ config, lib, pkgs, ... }:

{
  programs.beets = {
    enable = true;
    settings = builtins.readFile ./beets/config.yaml + ''
      directory: ${config.xdg.userDirs.extraConfig.MUSIC_DIR}
      library: ${config.xdg.userDirs.extraConfig.MUSIC_DIR}/library.db
    '';
  };
  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.extraConfig.MUSIC_DIR}";
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