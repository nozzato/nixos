{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    git
    neovim
    nyancat
    wget
  ];
}
