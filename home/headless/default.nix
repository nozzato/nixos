{ config, lib, pkgs, ... }: {
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
    ./bin.nix
    ./directories.nix
    ./git.nix
    ./networking.nix
    ./shell.nix
    ./vim.nix
    ./web.nix
  ];
}
