{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    nvidiaPatches = true;
    extraConfig = ''
      monitor = DP-2, 1920x1080, 0x0, 1
      monitor = DP-3, 1920x1080, 1920x0, 1
      monitor = eDP-1, 1920x1080, 3840x0, 1
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
