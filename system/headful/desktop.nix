{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    cage
    greetd.gtkgreet
    gtklock
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.cage}/bin/cage -ds -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -b " + toString ../../config/stylix/wallpaper.png;
        user = "greeter";
      };
      terminal = {
        vt = "1";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    Hyprland
    zsh
  '';
  security.pam.services.gtklock = {};

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs.dconf.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}