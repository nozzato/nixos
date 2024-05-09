{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  # Nix
  system.stateVersion = "23.11";

  # Snippet from https://github.com/Misterio77/nix-config/blob/main/flake.nix
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  nixpkgs.config.allowUnfree = true;

  # Hardware
  hardware.enableRedistributableFirmware = true;

  # Boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # User
  users.users = {
    noah = {
      isNormalUser = true;
      description = "Noah Torrance";
      shell = pkgs.fish;
      extraGroups = let
        # Snippet from https://github.com/Misterio77/nix-config/blob/main/flake.nix
        ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
      in [
        "wheel"
        "video"
        "audio"
        "network"
      ] ++ ifTheyExist [
        "syncthing"
      ];
    };
  };

  # Shell
  programs.fish.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Locale
  console.keyMap = "uk";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "C.UTF-8";
      LC_NAME = "C.UTF-8";
    };
  };

  time.timeZone = "Europe/London";

  # OpenSSH
  services.openssh.enable = true;
}
