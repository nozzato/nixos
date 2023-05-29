{ config, lib, pkgs, ... }: let
  nix-alien-pkgs = import (builtins.fetchTarball {
    url = "https://github.com/thiagokokada/nix-alien/tarball/master";
    sha256 = "sha256-Vxm1X653raqWrVaTplxmsrJqwCIBAPxS8gCxSYADGXU";
  }) {};
in {
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.packages = with pkgs; with nix-alien-pkgs; [
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
