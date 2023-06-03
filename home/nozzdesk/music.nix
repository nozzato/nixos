{ config, lib, pkgs, ... }: {
  services.playerctld.enable = true;

  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.extraConfig.MUSIC_DIR}";
    extraConfig = ''
      auto_update "yes"
      restore_paused "yes"

      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };
  services.mpd-mpris.enable = true;

  programs.ncmpcpp.enable = true;
}