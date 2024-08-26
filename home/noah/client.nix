{ lib, config, pkgs, ... }: {
  # TODO Plasma

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

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      mkhl.direnv
    ];
    userSettings = {
      "diffEditor.renderSideBySide" = false;
      "editor.fontSize" = 13;
      "editor.minimap.enabled" = false;
      "editor.scrollbar.verticalScrollbarSize" = 12;
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "files.insertFinalNewline" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "update.mode" = "none";
      "update.showReleaseNotes" = false;
    };
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

  # TODO Thunderbird

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

    ffmpeg
    libreoffice-fresh
    gimp-with-plugins
    audacity
    kdenlive
    blender
    godot_4

    plasma-browser-integration  # FIXME
    tor-browser
    discord
    whatsapp-for-linux
    qbittorrent  # TODO Dark theme
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
