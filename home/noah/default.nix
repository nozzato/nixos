{ config, ... }: {
  home = {
    username = "noah";
    homeDirectory = "/home/${config.home.username}";
  };

  programs.git = {
    userName = "Noah Torrance";
    userEmail = "noahtorrance27@gmail.com";
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
      cp = "cp -v";
      df = "df -h";
      diff = "diff --color=auto";
      du = "du -h";
      flush = "swapoff -a && sudo swapon -a";
      hms = "home-manager switch --flake ~/.config/nixos --print-build-logs";
      inhibit = "systemd-inhibit --what=shutdown:sleep:idle:handle-power-key:handle-suspend-key:handle-hibernate-key:handle-lid-switch";
      ip = "ip --color=auto";
      less = "less -i -x 2";
      ls = "ls -lAhvN --group-directories-first --time-style=long-iso --color=auto";
      mkdir = "mkdir -v";
      mv = "mv -v";
      nrb = "nixos-rebuild boot --flake ~/.config/nixos --use-remote-sudo --print-build-logs";
      nrs = "nixos-rebuild switch --flake ~/.config/nixos --use-remote-sudo --print-build-logs";
      pkill = "pkill -e";
      rcp = "rsync -vah --partial";
      rm = "rm -v";
      rmdir = "rmdir -v";
      rmv = "rsync -vah --partial --remove-source-files";
      rr = "trash-restore";
      rt = "trash-put";
      shred = "shred -v";
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };
}
