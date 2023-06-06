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
      Environment = "DISPLAY=wayland-0";
    };
    script = "${self.inputs.check-battery.packages.${system}.check-battery}/bin/check-battery";
  };
}
