{ config, lib, pkgs, ... }: {
  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    recommendedEnvironment = true;
    xwayland.enable = true;
    extraConfig = ''
      general {
        border_size = 1
        gaps_in = 0
        gaps_out = 0
        col.inactive_border = rgb(444444)
        col.active_border = rgb(444444)
        col.group_border = rgb(444444)
        col.group_border_active = rgb(444444)

        cursor_inactive_timeout = 15

        layout = dwindle
      }

      decoration {
        blur = false
      }

      animations {
        bezier = easeOutExpo, 0.16, 1, 0.3, 1

        enabled = true
        animation = windows, 1, 5, easeOutExpo, popin 80%
        animation = fade, 1, 5, easeOutExpo
        animation = workspaces, 1, 5, easeOutExpo
      }

      input {
        kb_layout = gb
        kb_options = compose:ralt, ctrl:nocaps
        numlock_by_default = true

        touchpad {
          clickfinger_behavior = true
          tap-to-click = true
          drag_lock = true
        }
      }

      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true

        key_press_enables_dpms = true

        enable_swallow = true
        swallow_regex = ^(Alacritty)$
      }

      binds {
        scroll_event_delay = true
        allow_workspace_cycles = true
      }

      dwindle {
        no_gaps_when_only = true

        preserve_split = true
      }

      master {
        no_gaps_when_only = true

        new_is_master = false
      }

      # Binds
      bindr = SUPER, d, exec, pkill wofi || wofi -i -S drun
      bind = SUPER, s, exec, dwa
      bind = SUPER SHIFT, s, exec, dwa -a
      bind = SUPER, return, exec, alacritty
      bind = SUPER SHIFT, return, exec, alacritty --class "Alacritty debug"
      bind = SUPER, a, exec, thunar
      bind = SUPER, z, togglespecialworkspace, scratchpad
      bind = SUPER SHIFT, z, exec, alacritty --class "Alacritty scratchpad"
      bind = SUPER, x, togglespecialworkspace, keepassxc
      bind = SUPER SHIFT, x, exec, keepassxc
      bindr = SUPER, semicolon, exec, pkill wofi || wofi-emoji
      bind = ,print, exec, grim ~/visual/capture/desktop/$(date +"%Y%m%dT%H%M%S").png
      bind = SUPER, print, exec, grim -g "$(hyprctl activewindow -j | jq -c '.at' | tr -d '[]') $(hyprctl activewindow -j | jq -c '.size' | tr -d '[]' | tr ',' 'x')" ~/visual/capture/desktop/$(date +"%Y%m%dT%H%M%S").png
      bind = SHIFT, print, exec, hyprpicker -r & grim -g "$(slurp)" ~/visual/capture/desktop/$(date +"%Y%m%dT%H%M%S").png && pkill hyprpicker
      bind = CONTROL, print, exec, hyprpicker -ar

      bind = ,XF86_AudioMute, exec, pamixer -t
      binde = ,XF86_AudioRaiseVolume, exec, pamixer -i 2
      binde = ,XF86_AudioLowerVolume, exec, pamixer -d 2
      bind = ,XF86_AudioPlay, exec, playerctl play-pause
      bind = SHIFT, XF86_AudioPlay, exec, playerctl stop
      binde = ,XF86_AudioNext, exec, playerctl next
      binde = ,XF86_AudioPrev, exec, playerctl previous
      binde = SHIFT ,XF86_AudioNext, exec, playerctl position 1+
      binde = SHIFT ,XF86_AudioPrev, exec, playerctl position 1-
      bindle = ,XF86_MonBrightnessUp, exec, sudo light -A 4
      bindle = ,XF86_MonBrightnessDown, exec, sudo light -U 4
      bindl = SHIFT, XF86_AudioMute, exec, rgb toggle

      binde = SUPER SHIFT, left, movewindow, l
      binde = SUPER SHIFT, right, movewindow, r
      binde = SUPER SHIFT, up, movewindow, u
      binde = SUPER SHIFT, down, movewindow, d
      binde = SUPER, h, splitratio, -0.10
      binde = SUPER, l, splitratio, +0.10
      bind = SUPER, j, togglesplit
      bind = SUPER, k, centerwindow

      bind = SUPER, c, togglefloating
      bind = SUPER, f, fullscreen, 1
      bind = SUPER SHIFT, f, fullscreen, 0
      bind = SUPER CONTROL SHIFT, f, fakefullscreen
      bind = SUPER, g, pin
      bind = SUPER, q, killactive
      bindlr = SUPER, m, exec, pkill wlogout || wlogout -p layer-shell

      binde = SUPER, left, movefocus, l
      binde = SUPER, left, bringactivetotop
      binde = SUPER, right, movefocus, r
      binde = SUPER, right, bringactivetotop
      binde = SUPER, up, movefocus, u
      binde = SUPER, up, bringactivetotop
      binde = SUPER, down, movefocus, d
      binde = SUPER, down, bringactivetotop

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10
      binde = SUPER, w, workspace, e-1
      binde = SUPER, e, workspace, e+1
      bind = SUPER, tab, workspace, previous
      bind = SUPER, mouse_down, workspace, e-1
      bind = SUPER, mouse_up, workspace, e+1

      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10
      bind = SUPER SHIFT, w, movetoworkspace, e-1
      bind = SUPER SHIFT, e, movetoworkspace, e+1
      bind = SUPER SHIFT, tab, movetoworkspace, previous

      bind = SUPER CONTROL SHIFT, 1, movetoworkspacesilent, 1
      bind = SUPER CONTROL SHIFT, 2, movetoworkspacesilent, 2
      bind = SUPER CONTROL SHIFT, 3, movetoworkspacesilent, 3
      bind = SUPER CONTROL SHIFT, 4, movetoworkspacesilent, 4
      bind = SUPER CONTROL SHIFT, 5, movetoworkspacesilent, 5
      bind = SUPER CONTROL SHIFT, 6, movetoworkspacesilent, 6
      bind = SUPER CONTROL SHIFT, 7, movetoworkspacesilent, 7
      bind = SUPER CONTROL SHIFT, 8, movetoworkspacesilent, 8
      bind = SUPER CONTROL SHIFT, 9, movetoworkspacesilent, 9
      bind = SUPER CONTROL SHIFT, 0, movetoworkspacesilent, 10
      bind = SUPER CONTROL SHIFT, w, movetoworkspacesilent, e-1
      bind = SUPER CONTROL SHIFT, e, movetoworkspacesilent, e+1
      bind = SUPER CONTROL SHIFT, tab, movetoworkspacesilent, previous

      bindm = SUPER, mouse:272, movewindow
      bind = SUPER, mouse:273, movecursortocorner, 1
      bindm = SUPER, mouse:273, resizewindow

      # Default apps
      windowrule = workspace 7 silent, ^(Steam)$
      windowrule = workspace 7 silent, ^(heroic)$
      windowrule = workspace 8 silent, ^(discord)$
      windowrule = workspace 8 silent, ^(whatsapp-for-linux)$
      windowrule = workspace 9 silent, ^(thunderbird)$
      windowrule = workspace 10 silent, ^(ncmpcpp)$
      windowrule = workspace special:scratchpad silent, ^(Alacritty scratchpad)$
      windowrule = workspace special:keepassxc silent, ^(org.keepassxc.KeePassXC)$

      # Startup apps
      exec-once = hyprpaper
      exec-once = mako

      exec-once = thunderbird
      exec-once = alacritty --class ncmpcpp -e ncmpcpp
      exec-once = alacritty --class "Alacritty scratchpad"
      exec-once = keepassxc
    '';
  };
  home.file."${config.xdg.configHome}/hypr/hyprpaper.conf".text = ''
    preload = '' + toString ../../assets/wallpaper.png + ''

    wallpaper= ,'' + toString ../../assets/wallpaper.png + ''
  '';
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 25;
        modules-left = [ "wlr/workspaces" "hyprland/window" ];
        modules-center = [];
        modules-right = [ "network" "cpu" "memory" "disk" "temperature" "wireplumber" "battery" "clock" ];

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format-icons = [ "" "" "" "" "" ];
          format = "{capacity:3}% {icon}";
        };
        clock = {
          interval = 1;
          format = "{:%a %F %T}";
          tooltip-format = "<tt>{calendar}</tt>";
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
          tooltip-format = "{ifname}: No IP address via {gwaddr}";
          tooltip-format-disconnected = "Disconnected";
        };
        temperature = {
          interval = 2;
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
  };
  services.mako = {
    enable = true;
    borderSize = 2;
    defaultTimeout = 8000;
    iconPath = "${pkgs.gnome-icon-theme}/share/icons/gnome";
    sort = "-priority";
  };
  programs.wofi = {
    enable = true;
  };
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "playerctl -a pause; gtklock -b " + toString ../../assets/wallpaper.png + " -H";
        text = "Lock";
        keybind = "m";
      }
      {
        label = "hibernate";
        action = "playerctl -a pause; gtklock -b " + toString ../../assets/wallpaper.png + " -HS & systemctl hibernate";
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
        action = "playerctl -a pause; gtklock -b " + toString ../../assets/wallpaper.png + " -HS & systemctl suspend";
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

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
  };
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
    ];
  };
  programs.obs-studio = {
    enable = true;
  };
  home.packages = with pkgs; [
    grim
    hyprpaper
    hyprpicker
    imv
    libnotify
    slurp
    wev
    wl-clipboard
    wofi-emoji
    wtype

    # Misc
    baobab
    filezilla
    gImageReader
    gparted
    sqlitebrowser
  ];

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
