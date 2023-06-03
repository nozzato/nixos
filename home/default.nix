{ config, lib, pkgs, stylix, ... }: {
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home = {
    username = "noah";
    homeDirectory = "/home/noah";
  };

  imports = [];
}