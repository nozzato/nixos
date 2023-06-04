{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    asciiquarium
    baobab
    cowsay
    exiftool
    filezilla
    gImageReader
    gparted
    hunspellDicts.en_GB-large
    jq
    light
    linuxwave
    mediainfo
    nyancat
    rnix-lsp
    soundOfSorting
    sqlitebrowser
    vimv-rs
    virt-manager
    wl-clipboard
    wofi-emoji
  ];
}
