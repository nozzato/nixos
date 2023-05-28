{ config, lib, pkgs, ... }: {
  home.stateVersion = "22.11";

  home.username = "noah";
  home.homeDirectory = "/home/noah";

  programs.home-manager.enable = true;
}