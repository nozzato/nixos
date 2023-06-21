{ config, lib, pkgs, ... }: {
  home.activation.linkLibreWolf = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ln -fs $VERBOSE_ARG \
        ${config.home.homeDirectory}/.mozilla/native-messaging-hosts \
        ${config.home.homeDirectory}/.librewolf/native-messaging-hosts
  '';
  programs.librewolf = {
    enable = true;
    settings = {
      "browser.download.dir" = "${config.home.homeDirectory}/download";
    };
  };
  programs.thunderbird = {
    enable = true;
    profiles.${config.home.username}.isDefault = true;
  };
  programs.yt-dlp = {
    enable = true;
  };
  home.packages = with pkgs; [
    discord
    nmap
    protonvpn-cli
    qbittorrent
    tor-browser-bundle-bin
    whatsapp-for-linux
  ];

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
  services.network-manager-applet.enable = true;
}
