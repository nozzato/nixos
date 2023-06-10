{ config, lib, pkgs, ... }: {
  systemd.user.timers."check-battery" = {
    wantedBy = [ "default.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "check-battery.service";
    };
  };
  systemd.user.services."check-battery" = {
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      state=$(cat /sys/class/power_supply/BAT0/status)
      level=$(cat /sys/class/power_supply/BAT0/capacity)

      if [[ $state == Discharging ]] && (( $level <= 5 )); then
        for i in {30..1}; do
          ${pkgs.libnotify}/bin/notify-send -u critical -i battery-caution -h string:x-canonical-private-synchronous:battery-critical -h int:value:$(${pkgs.bc}/bin/bc <<< "$i*100/30") "Hibernating in $i seconds"
          sleep 1
        done
        ${pkgs.libnotify}/bin/notify-send -t 1 -h string:x-canonical-private-synchronous:battery-critical " "
        ${pkgs.playerctl}/bin/playerctl -a pause
        ${pkgs.gtklock}/bin/gtklock -b "'' + toString ../../assets/wallpaper.png + ''" -HS & systemctl hibernate
      fi
    '';
  };
}
