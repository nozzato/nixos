{ lib, config, pkgs, ... }: {
  xdg.desktopEntries = {
    java = {
      name = "Java (JAR)";
      comment = "Execute a JAR file";
      icon = "${pkgs.breeze-icons}/share/icons/breeze-dark/mimetypes/64/application-x-jar.svg";
      exec = "java -jar %u";
      categories = [ "Application" "Utility" ];
      mimeType = [ "application/x-java-archive" ];
    };
  };

  services.easyeffects.enable = true;
  home.file = let
    repo = fetchGit {
      url = "https://github.com/JackHack96/EasyEffects-Presets";
      rev = "bd175d6f110e4053e3d0f4a0affd445fa5ecb814";
    };
  in {
    "${config.xdg.configHome}/easyeffects/output".source = "${repo}";
    "${config.xdg.configHome}/easyeffects/irs".source = "${repo}/irs";
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "identity.fxaccounts.enabled" = true;
      "privacy.resistFingerprinting" = false;
      "webgl.disabled" = false;
    };
  };
  home.activation.linkLibreWolf = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ${config.home.homeDirectory}/.mozilla/native-messaging-hosts \
      ${config.home.homeDirectory}/.librewolf/native-messaging-hosts
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json \
      ${config.home.homeDirectory}/.mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json \
  '';

  programs.yt-dlp = {
    enable = true;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts.emoji = [ "Blobmoji" ];
  };

  home.packages = with pkgs; with kdePackages; [
    openjdk

    keepassxc
    monero-gui

    ventoy

    spacedrive

    ffmpeg
    libreoffice-fresh
    calibre
    gimp-with-plugins
    aseprite
    audacity
    kdenlive
    blender
    godot_4
    fritzing

    plasma-browser-integration
    tor-browser
    kontact
    discord
    whatsapp-for-linux
    virt-viewer

    steam
    (retroarch.override {
      cores = with libretro; [
        beetle-psx-hw
        pcsx2
      ];
    })
    protontricks
    heroic
    prismlauncher

    noto-fonts-emoji-blob-bin
  ];
}
