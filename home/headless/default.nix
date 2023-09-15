{ config, lib, pkgs, self, system, ... }: {
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  programs.man.generateCaches = true;

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home = {
    username = "noah";
    homeDirectory = "/home/noah";
  };

  imports = [
    ./directories.nix
    ./git.nix
    ./networking.nix
    ./runners.nix
    ./shell.nix
    ./vim.nix
    ./web.nix
  ];
}
