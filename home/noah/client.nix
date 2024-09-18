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

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-ssh
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
      "remote.SSH.configFile" = "/etc/ssh/ssh_config";
      "remote.SSH.useLocalServer" = false;
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

  programs.thunderbird = {
    enable = true;
    profiles.${config.home.username}.isDefault = true;
  };

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
    calibre
    gimp-with-plugins
    aseprite
    audacity
    kdenlive
    blender
    unstable.godot_4
    fritzing

    plasma-browser-integration
    tor-browser
    discord
    whatsapp-for-linux
    qbittorrent
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
