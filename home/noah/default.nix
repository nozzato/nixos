{ config, pkgs, ... }: {
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
      grep = "grep -i";
      hms = "home-manager switch --flake ~/.config/nixos --print-build-logs";
      inhibit = "systemd-inhibit --what=shutdown:sleep:idle:handle-power-key:handle-suspend-key:handle-hibernate-key:handle-lid-switch";
      ip = "ip --color=auto";
      less = "less -i -x 2";
      ls = "ls -lAhvN --time-style=long-iso --color=auto";
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
      rsn = "rsync -vah --partial --mkpath --delete";
      rt = "trash-put";
      shred = "shred -v";
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    extensions = with pkgs.open-vsx; [
      jeanp413.open-remote-ssh
      jnoortheen.nix-ide
      cab404.vscode-direnv
    ];
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      "diffEditor.ignoreTrimWhitespace" = false;
      "diffEditor.renderSideBySide" = false;
      "editor.fontSize" = 13;
      "editor.minimap.enabled" = false;
      "editor.scrollbar.verticalScrollbarSize" = 12;
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "files.insertFinalNewline" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      "update.showReleaseNotes" = false;
    };
  };
}
