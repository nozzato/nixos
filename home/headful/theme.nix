{ config, lib, pkgs, stylix, ... }: {
  home.sessionVariables = {
    GTK_THEME = "adw-gtk3";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 16;
    gtk.enable = true;
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };

  stylix = {
    image = ../../assets/wallpaper.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-dark.yaml";
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

  home.packages = with pkgs; [
    gucharmap

    # Fonts
    corefonts
    dejavu_fonts
    font-awesome_6
    noto-fonts-emoji-blob-bin
    source-han-mono
    source-han-sans
    source-han-serif

    # Icons
    gnome-icon-theme
    gnome.adwaita-icon-theme

    # Sounds
    sound-theme-freedesktop
  ];
}
