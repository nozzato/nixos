{ config, lib, pkgs, ... }: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = rec {
        AUDIO_DIR = "${config.home.homeDirectory}/audio";
        MUSIC_DIR = "${AUDIO_DIR}/music";
        DOCUMENT_DIR = "${config.home.homeDirectory}/doc";
        DOWNLOAD_DIR = "${config.home.homeDirectory}/download";
        TEMPORARY_DIR = "${config.home.homeDirectory}/tmp";
        VISUAL_DIR = "${config.home.homeDirectory}/visual";
        SCREENSHOTS_DIR = "${VISUAL_DIR}/capture";
        DESKTOPSCREENSHOTS_DIR = "${SCREENSHOTS_DIR}/desktop";
        STEAMSCREENSHOTS_DIR = "${SCREENSHOTS_DIR}/steam";
      };
      desktop = null;
      documents = null;
      download = null;
      music = null;
      pictures = null;
      publicShare = null;
      templates = null;
      videos = null;
    };
  };
}