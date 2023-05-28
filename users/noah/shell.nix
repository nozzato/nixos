{ config, lib, pkgs, ... }: {
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    history.size = 999999999;
    history.save = 999999999;
    initExtra = builtins.readFile ./config/zsh/zshrc;
    shellAliases = {
      # Utils
      cat = "bat";
      chmod = "chmod -v";
      chown = "chown -v";
      cp = "cp -vi";
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
      rm = "rm -v";
      rt = "trash";
      shred = "shred -vuz";
      vim = "nvim";

      # Power
      lock = "playerctl -a pause; gtklock -H";
      hibernate = "playerctl -a pause; gtklock -H & systemctl hibernate";
      logout = "loginctl terminate-user $USER";
      poweroff = "systemctl poweroff";
      suspend = "playerctl -a pause; gtklock -H & systemctl suspend";
      reboot = "systemctl reboot";
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
}
