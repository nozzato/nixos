{ config, lib, pkgs, self, system, ... }: {
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.packages = with pkgs; with self.inputs.nix-alien.packages.${system}; with self.inputs.rgb-toggle.packages.${system}; with self.inputs.rsync-gnu.packages.${system}; [
    asciiquarium
    audacity
    baobab
    bc
    bfg-repo-cleaner
    blender-hip
    bsdgames
    cage
    chromaprint
    cowsay
    discord
    exfatprogs
    exiftool
    fd
    filezilla
    gImageReader
    gimp
    gnome-icon-theme
    gnome.adwaita-icon-theme
    godot
    gparted
    greetd.gtkgreet
    grim
    gtklock
    helvum
    heroic
    hip
    hunspellDicts.en_GB-large
    hyprpaper
    hyprpicker
    imv
    inkscape
    jq
    kdenlive
    keepassxc
    krita
    lf
    libnotify
    libreoffice-fresh
    light
    linuxwave
    mediainfo
    mkcert
    mpc-cli
    neofetch
    nix-alien
    nethogs
    nmap
    nodejs
    nvtop
    nyancat
    osu-lazer-bin
    p7zip
    pamixer
    pinta
    playerctl
    pods
    powertop
    prismlauncher
    proxychains-ng
    (pkgs.python3.withPackages (ps: with ps; [
      discogs-client
      pyacoustid
      requests
    ]))
    qbittorrent
    rar
    rawtherapee
    rgb-toggle
    ripgrep
    rnix-lsp
    rsync
    rsync-gnu
    slurp
    sound-theme-freedesktop
    soundOfSorting
    space-cadet-pinball
    sqlitebrowser
    stress
    tor-browser-bundle-bin
    trash-cli
    tree
    unzip
    ventoy
    veracrypt
    vimv-rs
    virt-manager
    w3m
    wev
    wget
    wl-clipboard
    wofi-emoji
    wtype
    zip

    # Fonts
    corefonts
    dejavu_fonts
    font-awesome_6
    google-fonts
    noto-fonts-emoji-blob-bin
    source-han-mono
    source-han-sans
    source-han-serif
  ];
}
