{ config, lib, pkgs, ... }: {
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
