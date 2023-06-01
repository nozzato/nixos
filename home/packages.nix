{ config, lib, pkgs, self, system, ... }: {
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.packages = with pkgs; with self.inputs.nix-alien.packages.${system}; with self.inputs.rgb-toggle.packages.${system}; [
    baobab
    bfg-repo-cleaner
    cage
    discord
    fd
    gimp
    gnome-icon-theme
    gnome.adwaita-icon-theme
    greetd.gtkgreet
    grim
    gtklock
    helvum
    heroic
    hip
    hyprpaper
    hyprpicker
    jq
    keepassxc
    lf
    libnotify
    libreoffice-fresh
    light
    mpc-cli
    neofetch
    nix-alien
    nodejs
    nvtop
    nyancat
    osu-lazer-bin
    pamixer
    playerctl
    pods
    rgb-toggle
    ripgrep
    rnix-lsp
    rsync
    rsync-gnu
    slurp
    sound-theme-freedesktop
    stress
    tor-browser-bundle-bin
    trash-cli
    veracrypt
    virt-manager
    w3m
    wev
    wget
    wl-clipboard
    wofi-emoji
    wtype

    # Fonts
    corefonts
    dejavu_fonts
    font-awesome_6
    noto-fonts-emoji-blob-bin
    source-han-mono
    source-han-sans
    source-han-serif
  ];
}
