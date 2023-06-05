{ config, lib, pkgs, ... }: {
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
    };
    script = ''
      state=$(cat /sys/devices/platform/smapi/BAT0/state)
      if [[ $state != Discharging ]]; then
        exit
      fi
      level=$(cat /sys/devices/platform/smapi/BAT0/remaining_percent)
      if [[ $level > 5 ]]; then
        exit
      fi

      for i in {30..1}; do
        notify-send -u critical -i battery-caution -h string:x-canonical-private-synchronous:check-battery -h int:value:$(bc <<< "$i*100/30") "Hibernating in $i seconds"
        sleep 1
      done
      notify-send -u critical -i battery-empty -h string:x-canonical-private-synchronous:check-battery -h int:value:$(bc <<< "$i*100/30") "Hibernating..."
      systemctl hibernate
    '';
  };
}