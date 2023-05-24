{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    recommendedEnvironment = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [
          "wlr/workspaces"
          "hyprland/window"
        ];
        modules-center = [];
        modules-right = [
          "tray"
          "network"
          "cpu"
          "memory"
          "disk"
          "temperature"
          "pulseaudio"
          "backlight"
          "battery"
          "clock"
        ];
        # Module config
        #backlight = {
          #device = "acpi_video1";
          #format = "{percent}% {icon}";
          #format-icons = [ "" "" "" "" "" "" "" "" "" ];
        #};
        #battery = {
          #states = {
            #good = 95;
            #warning = 30;
            #critical = 15;
          #};
          #format = "{capacity}% {icon}";
          #format-charging = "{capacity}% ";
          #format-plugged = "{capacity}% ";
          #format-alt = "{time} {icon}";
          #format-good = ""; # An empty format will hide the module
          #format-full = "";
          #format-icons = [ "" "" "" "" "" ];
        #};
        clock = {
          interval = 1;
          format = "{:%a %F %T}";
          tooltip-format = "<tt>{:%B %Y}\n{calendar}</tt>";
        };
        cpu = {
          interval = 2;
          format = "{usage:3}% ";
        };
        disk = {
          interval = 30;
          format = "{percentage_used:3}% ";
        };
        memory = {
          interval = 2;
          format = "{percentage:3}% ";
        };
        network = {
          interval = 2;
          format-ethernet = "{bandwidthDownBytes:>} {bandwidthUpBytes:>} ";
          format-wifi = "{bandwidthDownBytes:>} {bandwidthUpBytes:>} ";
          format-linked = "No IP address ";
          format-disconnected = "Disconnected ";
          tooltip-format-ethernet = "{ifname}: {ipaddr} via {gwaddr}";
          tooltip-format-wifi = "{ifname}: {ipaddr} via {gwaddr} on {essid}";
          tooltip-format = "{ifname}: (no IP address) via {gwaddr}";
          tooltip-format-disconnected = "(disconnected)";
        };
        pulseaudio = {
          format = "{volume:3}% ";
        };
        temperature = {
          interval = 2;
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
          critical-threshold = 80;
          format-icons = [ "" "" "" ];
          format = "{temperatureC:3}°C {icon}";
          tooltip-format = "{temperatureC}°C\n{temperatureF}°F\n{temperatureK}°K";
        };
        tray = {
          spacing = 10;
        };
        "hyprland/window" = {
        };
        wireplumber = {
          format = "{volume:3}% ";
        };
        "wlr/workspaces" = {
          sort-by-number = true;
          on-click = "activate";
        };
      };
    };
    style = builtins.readFile ./waybar/style.css;
  };
  programs.wofi = {
    enable = true;
  };
  programs.wlogout = {
    enable = true;
  };
  programs.alacritty = {
    enable = true;
  };
  programs.librewolf = {
    enable = true;
  };
}
