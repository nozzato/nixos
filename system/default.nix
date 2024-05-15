{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = let
        inputNames = lib.filter (n: n != "self") (lib.attrNames inputs);
        flaggedInputNames = lib.concatMap (n: ["--update-input" "${n}"]) inputNames;
      in flaggedInputNames ++ [
        "--commit-lock-file"
        "--print-build-logs"
      ];
      dates = "16:00";
    };
  };
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    optimise = {
      automatic = true;
      dates = [ "16:40" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
      dates = "15:40";
    };
  };
  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;

  hardware.enableRedistributableFirmware = true;
  services.gpm.enable = true;

  users.users = {
    noah = {
      isNormalUser = true;
      description = "Noah Torrance";
      extraGroups = let
        ifTheyExist = groups: lib.filter (group: lib.hasAttr group config.users.groups) groups;
      in [
        "wheel"
        "video"
        "audio"
        "networkmanager"
      ] ++ ifTheyExist [
        "syncthing"
        "adbusers"
      ];
      shell = pkgs.fish;
    };
  };

  programs.fish.enable = true;

  console.keyMap = "uk";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "C.UTF-8";
      LC_NUMERIC = "C.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };
  time.timeZone = "Europe/London";

  services.openssh.enable = true;

  programs.vim.defaultEditor = true;

  programs.htop.enable = true;

  environment.systemPackages = with pkgs; [
    exfatprogs
    ntfs3g
  ];
}
