{ config, lib, pkgs, stylix, ... }: {
  stylix = {
    image = ../config/stylix/wallpaper.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji-blob-bin;
        name = "Blobmoji";
      };
      sizes = {
        desktop = 14;
        applications = 10;
        terminal = 10;
        popups = 10;
      };
    };
  };
}