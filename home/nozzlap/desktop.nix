{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    nvidiaPatches = true;
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
