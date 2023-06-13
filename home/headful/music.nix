{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    mpc-cli
    playerctl
  ];

  services.playerctld.enable = true;

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/audio/music";
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

  programs.ncmpcpp = {
    enable = true;
    settings = {
      autocenter_mode = true;
      centered_cursor = true;
    };
  };
}
