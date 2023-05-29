{ config, lib, pkgs, ... }: {
  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    recommendedEnvironment = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
  };
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = '' + toString ../config/stylix/wallpaper.png + ''

    wallpaper= ,'' + toString ../config/stylix/wallpaper.png + ''
  '';
  programs.waybar = {
    enable = true;
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
    #style = builtins.readFile ../config/waybar/style.css;
  };
  programs.wofi = {
    enable = true;
  };
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "playerctl -a pause; gtklock -b " + toString ../config/stylix/wallpaper.png + " -H";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "playerctl -a pause; gtklock -b " + toString ../config/stylix/wallpaper.png + " -H & systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "playerctl -a pause; loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "playerctl -a pause; systemctl poweroff";
        text = "Poweroff";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "playerctl -a pause; gtklock -b " + toString ../config/stylix/wallpaper.png + " -H & systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "playerctl -a pause; systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
    };
  };
  programs.librewolf = {
    enable = true;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "diffEditor.renderSideBySide" = false;
      "editor.minimap.enabled" = false;
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "workbench.startupEditor" = "none";
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        preBuild = ''
          sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/' ../src/modules/wlr/workspace_manager.cpp
        '';
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
}
