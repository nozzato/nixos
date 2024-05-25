{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true;
    kwin = {
      titlebarButtons.left = [
        "more-window-actions"
        "keep-above-windows"
        "on-all-desktops"
      ];
      virtualDesktops = {
        number = 10;
        rows = 2;
        animation = "fade";
      };
    };
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
    };
    panels = [{
      height = 40;
      location = "top";
      floating = false;
      widgets = [
        "org.kde.plasma.kickoff"
        {
          name = "org.kde.plasma.showActivityManager";
          config = {
            General.showActivityName = "false";
          };
        }
        "org.kde.plasma.pager"
        "org.kde.plasma.marginsseparator"
        {
          name = "org.kde.plasma.taskmanager";
          config = {
            General.launchers = [ ];
          };
        }
        "org.kde.plasma.systemtray"
        "org.kde.plasma.systemmonitor.cpu"
        "org.kde.plasma.systemmonitor.memory"
        "org.kde.plasma.systemmonitor.diskactivity"
        "org.kde.plasma.systemmonitor.net"
        {
          name = "org.kde.plasma.digitalclock";
          config = {
            Appearance.showSeconds = "Always";
          };
        }
        "org.kde.plasma.notifications"
      ];
    }];
    configFile = {
      "kdeglobals" = {
        "KScreen" = {
          "XwaylandClientsScale" = false;
        };
        "KDE" = {
          "ShowDeleteCommand" = true;
        };
        "PreviewSettings" = {
          "MaximumRemoteSize" = 20971520;
        };
      };
      "kwinrc" = {
        "Effect-overview" = {
          "BorderActivate" = 9;
        };
        "NightColor" = {
          "Active" = true;
          "LatitudeAuto" = 51.48;
          "LongitudeAuto" = 0.00;
        };
        "Windows" = {
          "ElectricBorderCornerRatio" = 0.1;
          "FocusPolicy" = "FocusFollowsMouse";
          "DelayFocusInterval" = 0;
        };
        "SubSession: 76e37d3d-2fdf-40c0-a16e-cb82b16227c0" = {
          "active" = "-1";
          "count" = 0;
        };
        "SubSession: 7d8c4d04-8fc1-4430-ae41-29087970f786" = {
          "active" = "-1";
          "count" = 0;
        };
      };
      "kcminputrc" = {
        "Libinput/1241/41119/E-Signal USB Gaming Mouse" = {
          "PointerAcceleration" = 0.200;
          "PointerAccelerationProfile" = 1;
        };
        "Mouse" = {
          "X11LibInputXAccelProfileFlat" = true;
        };
        "Keyboard"."NumLock" = 0;
      };
      "kxkbrc" = {
        "Layout" = {
          "Use" = true;
          "LayoutList" = "gb";
          "ResetOldOptions" = true;
          "Options" = "compose:ralt";
        };
      };
      "kactivitymanagerdrc" = {
        "activities" = {
          "76e37d3d-2fdf-40c0-a16e-cb82b16227c0" = "Default";
          "7d8c4d04-8fc1-4430-ae41-29087970f786" = "Private";
        };
        "activities-icons" = {
          "76e37d3d-2fdf-40c0-a16e-cb82b16227c0" = "go-home-symbolic";
          "7d8c4d04-8fc1-4430-ae41-29087970f786" = "view-private";
        };
        "main" = {
          "currentActivity" = "76e37d3d-2fdf-40c0-a16e-cb82b16227c0";
          "runningActivities" = "76e37d3d-2fdf-40c0-a16e-cb82b16227c0,7d8c4d04-8fc1-4430-ae41-29087970f786";
        };
      };
      "plasma-localerc" = {
        "Formats" = {
          "LANG" = "en_GB.UTF-8";
          "LC_NUMERIC" = "C";
          "LC_NAME" = "C";
        };
      };
      "dolphinrc" = {
        "ContentDisplay" = {
          "UseShortRelativeDates" = false;
        };
        "DetailsMode" = {
          "PreviewSize" = 22;
        };
        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = false;
          "Places Icons Static Size" = 22;
        };
      };
    };
    shortcuts = {
      "services/org.kde.plasma.emojier.desktop" = {
        "_launch" = "Meta+;";
      };
      "services/org.kde.konsole.desktop" = {
        "_launch" = "Meta+T";
      };
      "services/org.kde.krunner.desktop" = {
        "_launch" = [ ];
        "RunClipboard" = [ ];
      };
      "services/org.kde.spectacle.desktop" = {
        "CurrentMonitorScreenShot" = "Ctrl+Print";
        "WindowUnderCursorScreenShot" = [ ];
        "RecordRegion" = "Meta+Shift+ScrollLock";
        "RecordScreen" = "ScrollLock";
        "RecordWindow" = "Meta+ScrollLock";
        "_launch" = "Print";
      };
      "kaccess" = {
        "Toggle Screen Reader On and Off" = [ ];
      };
      "kmix" = {
        "decrease_microphone_volume" = ["Ctrl+Volume Down" "Microphone Volume Down"];
        "increase_microphone_volume" = ["Microphone Volume Up" "Ctrl+Volume Up"];
        "mic_mute" = ["Ctrl+Volume Mute" "Microphone Mute"];
      };
      "org_kde_powerdevil" = {
        "Decrease Screen Brightness" = ["Alt+Volume Down" "Monitor Brightness Down"];
        "Decrease Screen Brightness Small" = ["Shift+Monitor Brightness Down" "Alt+Shift+Volume Down"];
        "Increase Screen Brightness" = ["Monitor Brightness Up" "Alt+Volume Up"];
        "Increase Screen Brightness Small" = ["Alt+Shift+Volume Up" "Shift+Monitor Brightness Up"];
        "Turn Off Screen" = "Alt+Volume Mute";
      };
      "kwin" = {
        "ClearMouseMarks" = [ ];
        "ShowDesktopGrid" = [ ];
        "ClearLastMouseMark" = [ ];
        "Suspend Compositing" = [ ];
        "Walk Through Desktops" = "Meta+Tab";
        "Cube" = [ ];
        "Walk Through Desktops (Reverse)" = "Meta+Shift+Tab";
        "Window Close" = "Meta+Q";
        "Window Above Other Windows" = "Meta+A";
        "Window On All Desktops" = "Meta+Shift+A";
        "Window Fullscreen" = "Meta+Ctrl+F";
        "Window Maximize" = "Meta+F";
        "Window Minimize" = "Meta+Shift+F";
        "Window to Next Screen" = [ ];
        "Window to Previous Screen" = [ ];
        "Window Move Center" = "Meta+C";
        "Window Quick Tile Bottom" = "Meta+Ctrl+Down";
        "Window Quick Tile Left" = "Meta+Ctrl+Left";
        "Window Quick Tile Right" = "Meta+Ctrl+Right";
        "Window Quick Tile Top" = "Meta+Ctrl+Up";
        "Switch One Desktop Down" = [ ];
        "Switch One Desktop to the Left" = [ ];
        "Switch One Desktop to the Right" = [ ];
        "Switch One Desktop Up" = [ ];
        "Switch to Desktop 1" = "Meta+!";
        "Switch to Desktop 2" = "Meta+\"";
        "Switch to Desktop 3" = "Meta+£";
        "Switch to Desktop 4" = "Meta+$";
        "Switch to Desktop 5" = "Meta+%";
        "Switch to Desktop 6" = "Meta+^";
        "Switch to Desktop 7" = "Meta+&";
        "Switch to Desktop 8" = "Meta+*";
        "Switch to Desktop 9" = "Meta+(";
        "Switch to Desktop 10" = "Meta+)";
        "Switch to Next Desktop" = "Meta+Shift+Right";
        "Switch to Previous Desktop" = "Meta+Shift+Left";
        "Switch Window Up" = "Meta+Up";
        "Switch Window Down" = "Meta+Down";
        "Switch Window Left" = "Meta+Left";
        "Switch Window Right" = "Meta+Right";
        "Grid View" = [ ];
        "Toggle Night Color" = "Meta+N";
        "Overview" = [ ];
        "ExposeAll" = [ ];
        "Expose" = [ ];
        "ExposeClass" = [ ];
        "Edit Tiles" = "Meta+S";
        "Walk Through Windows of Current Application" = [ ];
        "Walk Through Windows of Current Application (Reverse)" = [ ];
        "Window One Desktop Down" = [ ];
        "Window One Desktop to the Left" = [ ];
        "Window One Desktop to the Right" = [ ];
        "Window One Desktop Up" = [ ];
        "Window Operations Menu" = "Alt+Space";
        "Window to Desktop 1" = "Meta+Ctrl+!";
        "Window to Desktop 2" = "Meta+Ctrl+\"";
        "Window to Desktop 3" = "Meta+Ctrl+£";
        "Window to Desktop 4" = "Meta+Ctrl+$";
        "Window to Desktop 5" = "Meta+Ctrl+%";
        "Window to Desktop 6" = "Meta+Ctrl+^";
        "Window to Desktop 7" = "Meta+Ctrl+&";
        "Window to Desktop 8" = "Meta+Ctrl+*";
        "Window to Desktop 9" = "Meta+Ctrl+(";
        "Window to Desktop 10" = "Meta+Ctrl+)";
        "Window to Next Desktop" = "Meta+Ctrl+Shift+Right";
        "Window to Previous Desktop" = "Meta+Ctrl+Shift+Left";
        "view_zoom_in" = "Meta+=";
        "view_actual_size" = "Meta+Backspace";
      };
      "mediacontrol" = {
        "mediavolumedown" = "Shift+Media Previous";
        "mediavolumeup" = "Shift+Media Next";
        "stopmedia" = ["Ctrl+Media Play" "Media Stop"];
      };
      "plasmashell" = {
        "activate task manager entry 1" = "Meta+1";
        "activate task manager entry 2" = "Meta+2";
        "activate task manager entry 3" = "Meta+3";
        "activate task manager entry 4" = "Meta+4";
        "activate task manager entry 5" = "Meta+5";
        "activate task manager entry 6" = "Meta+6";
        "activate task manager entry 7" = "Meta+7";
        "activate task manager entry 8" = "Meta+8";
        "activate task manager entry 9" = "Meta+9";
        "activate task manager entry 10" = "Meta+0";
        "repeat_action" = [ ];
        "clipboard_action" = [ ];
        "manage activities" = [ ];
        "show dashboard" = [ ];
        "stop current activity" = [ ];
        "next activity" = "Ctrl+Tab";
        "previous activity" = "Ctrl+Shift+Tab";
      };
    };
  };

  xdg.desktopEntries = {
    java = {
      name = "Java (Jar)";
      exec = "java -jar %u";
      categories = [ "Application" ];
      mimeType = [ "application/x-java-archive" ];
    };
  };

  programs.kate = {
    enable = true;
    editor = {
      tabWidth = 2;
    };
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "identity.fxaccounts.enabled" = true;
      "privacy.resistFingerprinting" = false;
      "webgl.disabled" = false;
    };
  };
  home.activation.linkLibreWolf = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ${config.home.homeDirectory}/.mozilla/native-messaging-hosts \
      ${config.home.homeDirectory}/.librewolf/native-messaging-hosts
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json \
      ${config.home.homeDirectory}/.mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json \
  '';

  programs.yt-dlp = {
    enable = true;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts.emoji = [ "Blobmoji" ];
  };

  home.packages = with pkgs; with kdePackages; [
    openjdk

    keepassxc
    ventoy

    ffmpeg
    krita
    audacity
    kdenlive
    blender
    godot_4

    plasma-browser-integration
    tor-browser
    kontact
    kmail-account-wizard
    discord
    whatsapp-for-linux
    ktorrent
    virt-viewer

    steam
    (retroarch.override {
      cores = with libretro; [
        beetle-psx-hw
        pcsx2
      ];
    })
    protontricks
    heroic
    prismlauncher

    noto-fonts-emoji-blob-bin
  ];
}
