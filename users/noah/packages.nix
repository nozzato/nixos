{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    dejavu_fonts
    font-awesome
    fd
    git
    hip
    keepassxc
    neovim
    noto-fonts-emoji-blob-bin
    nyancat
    veracrypt
    wget
  ];
}
