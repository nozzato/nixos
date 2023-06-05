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
      state=$(cat /sys/class/power_supply/BAT0/status)
      if [[ $state != Discharging ]]; then
        exit
      fi
      level=$(cat /sys/class/power_supply/BAT0/capacity)
      if [[ $level > 5 ]]; then
        exit
      fi

      for i in {30..1}; do
        notify-send -u critical -i battery-caution -h string:x-canonical-private-synchronous:battery-critical -h int:value:$(bc <<< "$i*100/30") "Hibernating in $i seconds"
        sleep 1
      done
      notify-send -t 1 -h string:x-canonical-private-synchronous:battery-critical " "
      playerctl -a pause
      gtklock -b '' + toString ../../assets/wallpaper.png + '' -HS
      systemctl hibernate
    '';
  };
}