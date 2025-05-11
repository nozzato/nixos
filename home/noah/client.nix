{ lib, config, pkgs, ... }: {
  systemd.user.services.oidc-agent = {
    Unit = {
      Description = "Manage OpenID Connect tokens";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.oidc-agent}/bin/oidc-agent -d --log-stderr -a %t/oidc-agent";
    };
  };
  home.sessionVariablesExtra = ''
    export OIDC_SOCK=$XDG_RUNTIME_DIR/oidc-agent
  '';

  xdg.desktopEntries = {
    java = {
      name = "Java (JAR)";
      comment = "Execute a JAR file";
      icon = "${pkgs.kdePackages.breeze-icons}/share/icons/breeze-dark/mimetypes/64/application-x-jar.svg";
      exec = "java -jar %u";
      categories = [ "Application" "Utility" ];
      mimeType = [ "application/x-java-archive" ];
    };
  };

  services.owncloud-client.enable = true;
  xdg.configFile."rclone/rclone.conf".text = ''
    [owncloud]
    type = webdav
    url = https://owncloud.nozato.org/dav/spaces/0502fd3d-7f2f-41ca-87a2-577d93a203f4%2452cb396c-bc8b-4da7-9198-f0ee79e559f4/mount
    vendor = owncloud
    bearer_token_command = ${pkgs.oidc-agent}/bin/oidc-token owncloud
  '';
  systemd.user.services.rclone-owncloud = {
    Unit = {
      Description = "ownCloud Rclone mount";
      After = [ "oidc-agent.service" ];
      Requires = [ "oidc-agent.service" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "notify";
      ExecStart = (pkgs.writeShellScript "rclone-owncloud.sh" ''
        ${pkgs.oidc-agent}/bin/oidc-add --pw-file /run/secrets/system/client/oidc-agent_owncloud_password owncloud
        ${pkgs.rclone}/bin/rclone -v mount --vfs-cache-mode writes --no-checksum owncloud: /media/owncloud/mount
      '');
      ExecStop = "${pkgs.fuse}/bin/fusermount -u /media/owncloud/mount";
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
      ${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json \
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
    oidc-agent

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
    godot
    fritzing

    plasma-browser-integration
    tor-browser
    evolution
    discord
    whatsapp-for-linux
    virt-viewer

    steam
    (retroarch.withCores (cores: with cores; [
      beetle-psx-hw
      pcsx2
    ]))
    protontricks
    heroic
    prismlauncher

    noto-fonts-emoji-blob-bin
  ];
}
