{ config, lib, pkgs, ... }: let
  nix-alien-pkgs = import (builtins.fetchTarball {
    url = "https://github.com/thiagokokada/nix-alien/tarball/master";
    sha256 = "sha256-Vxm1X653raqWrVaTplxmsrJqwCIBAPxS8gCxSYADGXU";
  }) {};
in {
  home.packages = with pkgs; with nix-alien-pkgs; [
    cage
    dejavu_fonts
    discord
    font-awesome
    fd
    git
    gnome-icon-theme
    gnome.adwaita-icon-theme
    greetd.gtkgreet
    gtklock
    grim
    hip
    hyprpaper
    keepassxc
    light
    neovim
    nix-alien
    nodejs
    noto-fonts-emoji-blob-bin
    nyancat
    pamixer
    playerctl
    pods
    ripgrep
    slurp
    steam
    veracrypt
    wev
    wget
    wofi-emoji
  ];
}
