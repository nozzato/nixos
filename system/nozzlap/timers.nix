{ config, lib, pkgs, self, system, ... }: {
  systemd.timers."check-battery" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "check-battery.service";
    };
  };
  systemd.services."check-battery" = {
    serviceConfig = {
      Type = "oneshot";
      User = "noah";
      Environment = "PATH=/home/noah/.nix-profile/bin:/run/current-system/sw/bin:${pkgs.coreutils}/bin:${pkgs.findutils}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.systemd}/bin:${pkgs.coreutils}/sbin:${pkgs.findutils}/sbin:${pkgs.gnugrep}/sbin:${pkgs.gnused}/sbin:${pkgs.systemd}/sbin DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus DISPLAY=wayland-0";
    };
    script = "${self.inputs.check-battery.packages.${system}.check-battery}/bin/check-battery";
  };
}
