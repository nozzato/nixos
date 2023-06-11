{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor = HDMI-A-1, 1920x1080, 0x0, 1
    '';
  };
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
