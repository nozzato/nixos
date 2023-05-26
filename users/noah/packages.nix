{ config, lib, pkgs, ... }:
let
  nix-alien-pkgs = import (builtins.fetchTarball {
    url = "https://github.com/thiagokokada/nix-alien/tarball/master";
    sha256 = "sha256-Vxm1X653raqWrVaTplxmsrJqwCIBAPxS8gCxSYADGXU";
  }) {};
in
{
  home.packages = with pkgs; with nix-alien-pkgs; [
    dejavu_fonts
    discord
    font-awesome
    fd
    git
    hip
    keepassxc
    neovim
    nix-alien
    noto-fonts-emoji-blob-bin
    nyancat
    pods
    ripgrep
    steam
    veracrypt
    wget
  ];
}
