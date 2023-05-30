{ config, lib, pkgs, self, system, ... }: {
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.packages = with pkgs; with self.inputs.nix-alien.packages.${system}; with self.inputs.rgb-toggle.packages.${system}; [
    baobab
    bfg-repo-cleaner
    cage
    dejavu_fonts
    discord
    font-awesome
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
    htop
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
    noto-fonts-emoji-blob-bin
    nyancat
    osu-lazer-bin
    pamixer
    playerctl
    pods
    rgb-toggle
    ripgrep
    rnix-lsp
    slurp
    stress
    tor-browser-bundle-bin
    trashy
    veracrypt
    w3m
    wev
    wget
    wl-clipboard
    wofi-emoji
    wtype
  ];
}
