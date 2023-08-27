{ config, lib, pkgs, ... }: {
  home.file."${config.xdg.configHome}/hypr/hyprland.conf".text = ''
    monitor = eDP-1, 1920x1080, 0x0, 1

    #monitor = DP-2, 1920x1080, 0x0, 1, transform, 1
    #monitor = DP-3, 1920x1080, 1080x420, 1
    #monitor = eDP-1, 1920x1080, 3000x420, 1
    #workspace = 9, monitor:DP-2
    #workspace = 10, monitor:eDP-1

    #monitor = eDP-1, 1920x1080, 0x1080, 1
    #monitor = HDMI-A-2, 1920x1080, 0x0, 1
  '';
  programs.waybar = {
    settings = {
      mainBar = {
        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
        };
      };
    };
  };
}
