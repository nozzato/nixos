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
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      style = "plain";
      paging = "never";
    };
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
    ripgrep
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
