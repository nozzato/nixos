{ config, lib, pkgs, stylix, ... }: {
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home = {
    username = "noah";
    homeDirectory = "/home/noah";
  };

  imports = [];
}