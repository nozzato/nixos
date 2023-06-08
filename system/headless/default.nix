{ config, lib, pkgs, self, system, ... }: {
  system.stateVersion = "22.11";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "45m";
    persistent = true;
  };

  documentation.man.generateCaches = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  imports = [
    ./bootloader.nix
    ./console.nix
    ./filesystems.nix
    ./networking.nix
    ./patcher.nix
    ./sudo.nix
  ];
}
