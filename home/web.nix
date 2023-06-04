{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    mkcert
    proxychains-ng
  ];
}