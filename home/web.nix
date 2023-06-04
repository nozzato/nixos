{ config, lib, pkgs, ... }: {
  home.packages = [
    mkcert
    proxychains-ng
  ];
}