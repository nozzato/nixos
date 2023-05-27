{ config, lib, pkgs, ... }:
let
  nix-alien-pkgs = import (builtins.fetchTarball {
    url = "https://github.com/thiagokokada/nix-alien/tarball/master";
    sha256 = "sha256-Vxm1X653raqWrVaTplxmsrJqwCIBAPxS8gCxSYADGXU";
  }) {};
in
{
  home.packages = with pkgs; with nix-alien-pkgs; [
    cage
    dejavu_fonts
    discord
    font-awesome
    fd
    git
    greetd.gtkgreet
    hip
    keepassxc
    neovim
    nix-alien
    nodejs
    noto-fonts-emoji-blob-bin
    nyancat
    pods
    ripgrep
    steam
    veracrypt
    wget
  ];
}
