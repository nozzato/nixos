{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    history.size = 999999999;
    history.save = 999999999;
    initExtra = builtins.readFile ../config/zsh/zshrc;
    shellAliases = {
      # Utils
      cat = "bat";
      chmod = "chmod -v";
      chown = "chown -v";
      cp = "cp -vir";
      df = "df -h";
      diff = "diff --color=auto";
      grep = "rg -S";
      history = "history -i";
      ip = "ip --color=auto";
      less = "less -i -x 2";
      ls = "ls -lAhvN --group-directories-first --time-style=long-iso --color=auto";
      mv = "mv -vi";
      nvtop = "nvtop -p";
      pkill = "pkill -e";
      rm = "rm -vr";
      rr = "trash-restore";
      rt = "trash-put";
      rsync = "rsync-gnu";
      rcp = "rsync-gnu -rptgoDh --partial --modify-window=1 --info=stats1,progress2";
      rmv = "rsync-gnu -rptgoDh --partial --modify-window=1 --info=stats1,progress2 --remove-source-files";
      shred = "shred -vuz";
      vim = "nvim";

      # Power
      lock = "playerctl -a pause; gtklock -b " + toString ../config/stylix/wallpaper.png + " -H";
      hibernate = "playerctl -a pause; gtklock -b " + toString ../config/stylix/wallpaper.png + " -HS & systemctl hibernate";
      logout = "playerctl -a pause; loginctl terminate-user $USER";
      poweroff = "playerctl -a pause; systemctl poweroff";
      suspend = "playerctl -a pause; gtklock -b " + toString ../config/stylix/wallpaper.png + " -HS & systemctl suspend";
      reboot = "playerctl -a pause; systemctl reboot";
      inhibit = "systemd-inhibit --what=shutdown:sleep:idle:handle-power-key:handle-suspend-key:handle-hibernate-key:handle-lid-switch";

      # Chain
      sudo = "sudo ";
    };
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
    };
  };
  programs.yt-dlp = {
    enable = true;
  };
}
