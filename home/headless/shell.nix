{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
    };
    shellAliases = {
      chmod = "chmod -v";
      chown = "chown -v";
      cp = "cp -vi";
      df = "df -h";
      diff = "diff --color=auto";
      du = "du -h";
      flush = "swapoff -a && sudo swapon -a";
      hyprpicker = "hyprpicker -ar";
      ip = "ip --color=auto";
      less = "less -i -x 2";
      ls = "ls -lAhvN --group-directories-first --time-style=long-iso --color=auto";
      mkdir = "mkdir -v";
      mv = "mv -vi";
      nvtop = "nvtop -p";
      pkill = "pkill -e";
      rcp = "rsync -ah --partial --modify-window=1 --info=stats1,progress2";
      rm = "rm -vI";
      rmdir = "rmdir -v";
      rmv = "rsync -ah --partial --modify-window=1 --info=stats1,progress2 --remove-source-files";
      rr = "trash-restore";
      rt = "trash-put";
      shred = "shred -vu";
      wl-copy = "wl-copy -n";

      # Power
      lock = "playerctl -a pause; gtklock -b " + toString ../assets/wallpaper.png + " -HS";
      hibernate = "systemctl hibernate";
      logout = "playerctl -a pause; loginctl terminate-user $USER";
      poweroff = "systemctl poweroff";
      suspend = "systemctl suspend";
      reboot = "systemctl reboot";
      inhibit = "systemd-inhibit --what=shutdown:sleep:idle:handle-power-key:handle-suspend-key:handle-hibernate-key:handle-lid-switch";
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.htop = {
    enable = true;
    settings = {
      delay = 10;
      screen_tabs = true;
    };
  };
  programs.nix-index = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
  programs.nix-index-database.comma.enable = true;
  home.packages = with pkgs; [
    bc
    calc
    exiftool
    fd
    ffmpeg
    gdb
    hunspellDicts.en_GB-large
    jq
    lf
    lm_sensors
    ltrace
    mediainfo
    mtr
    neofetch
    nethogs
    nvtop
    p7zip
    powertop
    rar
    rsync
    socat
    strace
    stress
    inetutils
    trash-cli
    tree
    unzip
    usbutils
    vimv-rs
    w3m
    wget
    zip
  ];
}
