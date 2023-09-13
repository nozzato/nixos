{ config, lib, pkgs, ... }: {
  systemd.services."shutdown" = {
    wantedBy = [ "shutdown.target" ];
    after = [ "shutdown.target" ];
    environment = {
      DISPLAY = ":0";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
    };
    serviceConfig = {
      User = "noah";
      Type = "oneshot";
    };
    script = ''
      ${pkgs.playerctl}/bin/playerctl -a pause
      sleep 1
    '';
  };
  systemd.services."sleep" = {
    wantedBy = [ "sleep.target" ];
    after = [ "sleep.target" ];
    environment = {
      DISPLAY = ":0";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
    };
    serviceConfig = {
      User = "noah";
      Type = "oneshot";
    };
    script = ''
      ${pkgs.playerctl}/bin/playerctl -a pause
      sleep 1
      ${pkgs.systemd}/bin/systemctl --user --machine=noah@ start --wait sleep.target
    '';
  };
  systemd.user.targets."sleep" = {
    wants = [ "sleep.service" ];
    unitConfig = {
      StopWhenUnneeded = true;
    };
  };
  systemd.user.services."sleep" = {
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.gtklock}/bin/gtklock -b "'' + toString ../../assets/wallpaper.png + ''" -HS
    '';
  };
}
