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
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.cage}/bin/cage -ds -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -b " + toString ../../assets/wallpaper.png;
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

  services.dbus.packages = [
    (pkgs.writeTextFile rec {
      name = "session-local.conf";
      destination = "/etc/dbus-1/session.d/${name}";
      text = ''
        <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
        "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
        <busconfig>
          <auth>ANONYMOUS</auth>
          <allow_anonymous/>
        </busconfig>
      '';
    })
  ];
  programs.dconf.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
