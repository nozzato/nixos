{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    history.size = 999999999;
    history.save = 999999999;
    shellAliases = {
      # Utils
      cat = "bat";
      chmod = "chmod -v";
      chown = "chown -v";
      cp = "cp -vir";
      df = "df -h";
      diff = "diff --color=auto";
      flush = "swapoff -a && sudo swapon -a";
      grep = "rg -S";
      history = "history -i";
      hyprpicker = "hyprpicker -ar";
      ip = "ip --color=auto";
      less = "less -i -x 2";
      ls = "ls -lAhvN --group-directories-first --time-style=long-iso --color=auto";
      mkdir = "mkdir -v";
      mv = "mv -vi";
      nvtop = "nvtop -p";
      pkill = "pkill -e";
      rm = "rm -vr";
      rmdir = "rmdir -v";
      rr = "trash-restore";
      rt = "trash-put";
      rsync = "grsync";
      rcp = "grsync -ah --partial --modify-window=1 --info=stats1,progress2";
      rmv = "grsync -ah --partial --modify-window=1 --info=stats1,progress2 --remove-source-files";
      shred = "shred -vuz";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      wl-copy = "wl-copy -n";

      # Power
      lock = "playerctl -a pause; gtklock -b " + toString ../assets/wallpaper.png + " -H";
      hibernate = "playerctl -a pause; gtklock -b " + toString ../assets/wallpaper.png + " -HS & systemctl hibernate";
      logout = "playerctl -a pause; loginctl terminate-user $USER";
      poweroff = "playerctl -a pause; systemctl poweroff";
      suspend = "playerctl -a pause; gtklock -b " + toString ../assets/wallpaper.png + " -HS & systemctl suspend";
      reboot = "playerctl -a pause; systemctl reboot";
      inhibit = "systemd-inhibit --what=shutdown:sleep:idle:handle-power-key:handle-suspend-key:handle-hibernate-key:handle-lid-switch";

      # Chain
      sudo = "sudo ";
    };
    initExtra = ''
      unsetopt FLOW_CONTROL
      setopt INTERACTIVECOMMENTS

      # Completion
      setopt NO_LIST_AMBIGUOUS

      zstyle :compinstall filename "/home/noah/.zshrc"
      autoload -Uz compinit
      compinit

      ## Menu
      zstyle ":completion:*" menu select

      zmodload zsh/complist
      bindkey -M menuselect "^[[Z" reverse-menu-complete

      ## Case-insensitive
      zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "m:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*" "m:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*" "m:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*"

      ## Colour
      zstyle ":completion:*" list-colors "''${(s.:.)LS_COLORS}"

      # Hooks
      autoload -Uz add-zsh-hook

      ## Dynamic title
      TERMINAL=$(basename "$(cat "/proc/$PPID/comm")")

      xterm_title_precmd() {
        print -Pn -- "\e]2;''${(C)TERMINAL} - [%n@%m:%~]%#\a"
      }
      xterm_title_preexec() {
        print -Pn -- "\e]2;''${(C)TERMINAL} - [%n@%m:%~]%# " && print -n -- "''${(q)1}\a"
      }

      if [[ "$TERM" != linux ]]; then
        add-zsh-hook -Uz precmd xterm_title_precmd
        add-zsh-hook -Uz preexec xterm_title_preexec
      fi

      # Tweaks

      ## Keep space before pipe
      ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

      ## Fix clear
      clear_screen() {
        echoti clear
        precmd
        zle redisplay
      }
      zle -N clear_screen

      # Prompt
      setopt PROMPT_SP
      setopt PROMPT_SUBST

      autoload -U promptinit
      promptinit

      PROMPT="%(!.%F{red}.%F{green})%B[%n@%m:%~]%#%b%f "

      # Navigation
      setopt AUTO_PUSHD
      setopt CD_SILENT
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHDMINUS

      # vi mode
      bindkey -v

      ## Remove delay when entering normal mode
      KEYTIMEOUT=5

      ## Change cursor shape for different modes
      zle-keymap-select() {
        case $KEYMAP in
          vicmd)
            echo -ne "\e[1 q" # block
            ;;
          viins|main)
            echo -ne "\e[5 q" # bar
            ;;
        esac
      }
      zle -N zle-keymap-select

      zle-line-init() {
        echo -ne "\e[5 q"
      }
      zle -N zle-line-init

      ## Change cursor shape to bar on startup
      echo -ne "\e[5 q"
      ## Change cursor shape to bar for each new prompt
      preexec() {
        echo -ne "\e[5 q" ;
      }

      # Binds
      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      typeset -g -A key

      key[Home]="''${terminfo[khome]}"
      key[End]="''${terminfo[kend]}"
      key[Insert]="''${terminfo[kich1]}"
      key[Backspace]="''${terminfo[kbs]}"
      key[Delete]="''${terminfo[kdch1]}"
      key[Up]="''${terminfo[kcuu1]}"
      key[Down]="''${terminfo[kcud1]}"
      key[Left]="''${terminfo[kcub1]}"
      key[Right]="''${terminfo[kcuf1]}"
      key[PageUp]="''${terminfo[kpp]}"
      key[PageDown]="''${terminfo[knp]}"
      key[Shift-Tab]="''${terminfo[kcbt]}"

      [[ -n "''${key[Home]}" ]] && bindkey -- "''${key[Home]}" beginning-of-line
      [[ -n "''${key[End]}" ]] && bindkey -- "''${key[End]}" end-of-line
      [[ -n "''${key[Insert]}" ]] && bindkey -- "''${key[Insert]}" overwrite-mode
      [[ -n "''${key[Backspace]}" ]] && bindkey -- "''${key[Backspace]}" backward-delete-char
      [[ -n "''${key[Delete]}" ]] && bindkey -- "''${key[Delete]}" delete-char
      [[ -n "''${key[Up]}" ]] && bindkey -- "''${key[Up]}" up-line-or-history
      [[ -n "''${key[Down]}" ]] && bindkey -- "''${key[Down]}" down-line-or-history
      [[ -n "''${key[Left]}" ]] && bindkey -- "''${key[Left]}" backward-char
      [[ -n "''${key[Right]}" ]] && bindkey -- "''${key[Right]}" forward-char
      [[ -n "''${key[PageUp]}" ]] && bindkey -- "''${key[PageUp]}" up-line-or-beginning-search
      [[ -n "''${key[PageDown]}" ]] && bindkey -- "''${key[PageDown]}" down-line-or-beginning-search
      [[ -n "''${key[Shift-Tab]}" ]] && bindkey -- "''${key[Shift-Tab]}" reverse-menu-complete
      bindkey "^X" push-line-or-edit

      ## Enter application mode when zle is active
      if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
        autoload -Uz add-zle-hook-widget

        zle_application_mode_start() {
          echoti smkx
        }
        zle_application_mode_stop() {
          echoti rmkx
        }

        add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
        add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
      fi

      # Syntax highlighting
      typeset -A ZSH_HIGHLIGHT_STYLES

      ZSH_HIGHLIGHT_STYLES[alias]=fg=magenta
      ZSH_HIGHLIGHT_STYLES[function]=fg=magenta
      ZSH_HIGHLIGHT_STYLES[comment]=fg=246
      ZSH_HIGHLIGHT_STYLES[path]=fg=cyan

      ## Disable highlighting pasted text
      zle_highlight+=(paste:none)
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
    };
  };
  programs.nix-index.enable = false;
  programs.nix-index-database.comma.enable = true;
  home.packages = with pkgs; [
    bc
    calc
    exiftool
    fd
    hunspellDicts.en_GB-large
    jq
    lf
    lm_sensors
    mediainfo
    neofetch
    nethogs
    nvtop
    p7zip
    powertop
    rar
    ripgrep
    rsync
    stress
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
