{ config, lib, pkgs, ... }: {
  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
  };

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
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
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "wlr/workspaces" "hyprland/window" ];
        modules-center = [];
        modules-right = [ "network" "cpu" "memory" "disk" "temperature" "wireplumber" "backlight" "battery" "clock" ];
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
          tooltip-format = "{used}GiB used out of {total}GiB ({percentage}%)";
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
        temperature = {
          interval = 2;
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
          critical-threshold = 80;
          format-icons = [ "" "" "" ];
          format = "{temperatureC:3}°C {icon}";
          tooltip-format = "{temperatureC}°C\n{temperatureF}°F\n{temperatureK}°K";
        };
        "hyprland/window" = {
        };
        wireplumber = {
          format = "{volume:3}% ";
        };
        "wlr/workspaces" = {
          sort-by-number = true;
          on-click = "activate";
        };
      };
    };
    #style = builtins.readFile ../config/waybar/style.css;
  };
  services.mako = {
    enable = true;
    borderSize = 2;
    defaultTimeout = 8000;
    iconPath = "${pkgs.gnome-icon-theme}/share/icons/gnome";
    sort = "-priority";
    extraConfig = lib.mkBefore ''
      on-notify=exec mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message.oga
    '';
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
        keybind = "m";
      }
      {
        label = "hibernate";
        action = "playerctl -a pause; gtklock -b " + toString ../config/stylix/wallpaper.png + " -HS & systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "playerctl -a pause; loginctl terminate-user $USER";
        text = "Logout";
        keybind = "l";
      }
      {
        label = "shutdown";
        action = "playerctl -a pause; systemctl poweroff";
        text = "Poweroff";
        keybind = "p";
      }
      {
        label = "suspend";
        action = "playerctl -a pause; gtklock -b " + toString ../config/stylix/wallpaper.png + " -HS & systemctl suspend";
        text = "Suspend";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "playerctl -a pause; systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = ''
      window {
	      background-color: rgba(0, 0, 0, 0.2);
      }
      button {
        border-radius: 0;
        background-color: @window_bg_color;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      #lock {
        border-radius: 6px 0 0 0;
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
      }
      #hibernate {
        border-radius: 0 0 0 6px;
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
      }
      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
      }
      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
      }
      #suspend {
        border-radius: 0 6px 0 0;
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
      }
      #reboot {
        border-radius: 0 0 6px 0;
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
      }
    '';
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
  home.file.".config/libvirt/qemu.conf".source = ../config/libvirt/qemu.conf;
  programs.obs-studio = {
    enable = true;
  };
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
    ];
  };
  home.activation = {
    clearThunar = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      $DRY_RUN_CMD rm -f $VERBOSE_ARG \
          ${config.xdg.configHome}/xfce4/xfconf/xfce-perchannel-xml/thunar.xml \
          ${config.xdg.configHome}/Thunar/uca.xml \
          ${config.xdg.configHome}/gtk-3.0/bookmarks
    '';
  };
  home.file.".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".source = ../config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml;
  home.file.".config/Thunar/uca.xml".source = ../config/Thunar/uca.xml;
  home.file.".config/gtk-3.0/bookmarks".source = ../config/gtk-3.0/bookmarks;
  programs.thunderbird = {
    enable = true;
    profiles.${config.home.username}.isDefault = true;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      jnoortheen.nix-ide
      mkhl.direnv
    ];
    userSettings = {
      diffEditor = {
        renderSideBySide = false;
      };
      editor = {
        fontSize = 13;
        lineDecorationsWidth = 0;
        minimap.enabled = false;
        roundedSelection = false;
        scrollbar.verticalScrollbarSize = 12;
        tabSize = 2;
        wordWrap = "on";
      };
      nix = {
        enableLanguageServer = true;
      };
      workbench = {
        editor.untitled.hint = "hidden";
        startupEditor = "none";
      };
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        preBuild = ''
          sed -i -e 's#zext_workspace_handle_v1_activate(workspace_handle_);#const std::string command = "${pkgs.hyprland}/bin/hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());#' ../src/modules/wlr/workspace_manager.cpp
        '';
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
}
