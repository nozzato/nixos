{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  home = {
    stateVersion = "23.11";
    username = "noah";
    homeDirectory = "/home/${config.home.username}";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Noah Torrance";
    userEmail = "noahtorrance27@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        ff = "only";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.ssh = {
    enable = true;
    userKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts " + builtins.toFile "known_hosts" ''
      github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
      github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
      github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
    '';
  };

  programs.vim.enable = true;

  programs.plasma = {
    enable = true;
    configFile = {
      "kdeglobals" = {
        "KDE" = {
          "SingleClick" = false;
        };
        "KScreen" = {
          "XwaylandClientsScale" = false;
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
      "kwinrc" = {
        "NightColor" = {
          "Active" = true;
        };
        "Windows" = {
          "ElectricBorderCornerRatio" = 0.1;
          "FocusPolicy" = "FocusFollowsMouse";
          "DelayFocusInterval" = 0;
        };
        "Desktops" = {
          "Number" = 10;
          "Rows" = 2;
          "Id_1" = "df5af85f-0976-43bf-9ee9-03a7d00bc400";
          "Id_2" = "189e0eeb-4c4b-410d-bcca-310cb13b71ee";
          "Id_3" = "27fd1a52-54a5-440a-8e98-11a80805eaa2";
          "Id_4" = "6e3e29e7-c131-4ccd-9181-7b73c4e5b4f4";
          "Id_5" = "0402c47a-ed1c-4fb4-99bf-14f98d424c18";
          "Id_6" = "e08da921-07dd-48c0-89a9-87dc0ec2c20f";
          "Id_7" = "00c94630-1cc9-4751-a04b-0e8899fcea90";
          "Id_8" = "fca7d73f-b540-4e05-a404-630b93e94c71";
          "Id_9" = "1ffec5c7-a36a-42f8-b631-20582ab3731f";
          "Id_10" = "6c79a4b3-36be-4ca6-bb9e-02577080d123";
        };
        "Plugins" = {
          "desktopchangeosdEnabled" = false;
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
          "LC_TIME" = "en_SE.UTF-8";
          "LC_NAME" = "C";
        };
      };
      "dolphinrc" = {
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
        "Window Fullscreen" = "Meta+Shift+F";
        "Window Maximize" = "Meta+F";
        "Window Minimize" = "Meta+Ctrl+F";
        "MoveMouseToCenter" = "Meta+C";
        "Window to Next Screen" = [ ];
        "Window to Previous Screen" = [ ];
        "Window Move Center" = "Meta+Shift+C";
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

  home.packages = with pkgs; [
    gocryptfs
    kate
    firefox
    thunderbird
    steam
    keepassxc
  ];
}
