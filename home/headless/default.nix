{ config, lib, pkgs, self, system, stylix, ... }: {
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home = {
    username = "noah";
    homeDirectory = "/home/noah";
  };

  imports = [
    ./bin.nix
    ./directories.nix
    ./git.nix
    ./networking.nix
    ./shell.nix
    ./vim.nix
    ./web.nix
  ];
}