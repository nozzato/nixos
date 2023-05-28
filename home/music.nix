{ config, lib, pkgs, ... }: {
  services.playerctld = {
    enable = true;
  };
  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.extraConfig.MUSIC_DIR}";
    extraConfig = builtins.readFile ./config/mpd/mpd.conf;
  };
  services.mpd-mpris = {
    enable = true;
  };

  programs.beets = {
    enable = true;
    settings = {
      directory = "${config.xdg.userDirs.extraConfig.MUSIC_DIR}";
      library = "${config.xdg.userDirs.extraConfig.MUSIC_DIR}/library.db";
      import = {
        from_scratch = true;
        timid = true;
      };
      replace = {
        "[\\\\/]" = "_";
        "^\\." = "_";
        "[\\x00-\\x1f]" = "_";
        "[<>:\"\\?\\*\\|]" = "_";
        "\\.$" = "_";
        "\\s+$" = "";
        "^\\s+" = "";
        "^-" = "_";
        "’" = "'";
        "[“”]" = "\"";
      };
      musicbrainz = {
        genre = true;
      };
      plugins = [
        "bandcamp"
        "chroma"
        "discogs"
        "edit"
        "fetchart"
        "fromfilename"
        "fuzzy"
        "info"
        "mbsync"
        "missing"
        "mpdupdate"
        "scrub"
        "spotify"
        "zero"
      ];
      discogs = {
        source_weight = 0.5;
      };
      bandcamp = {
        source_weight = 0.6;
      };
      spotify = {
        source_weight = 0;
      };
      fuzzy = {
        prefix = "@";
      };
      zero = {
        fields = "images";
        update_database = true;
      };
    };
  };
  programs.ncmpcpp = {
    enable = true;
  };
}