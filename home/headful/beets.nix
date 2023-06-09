{ config, lib, pkgs, ... }: {
  programs.beets = {
    enable = true;
    settings = {
      directory = "${config.home.homeDirectory}/audio/music";
      library = "${config.home.homeDirectory}/audio/music/library.db";
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

  home.packages = with pkgs; [
    chromaprint
    (pkgs.python3.withPackages (ps: with ps; [
      discogs-client
      pyacoustid
      requests
    ]))
  ];
}