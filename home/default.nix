{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  systemd.user.startServices = "sd-switch";
  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "16:20";
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.nix-index = {
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    gocryptfs
    p7zip

    calc

    wget
    inetutils

    trash-cli
    fd
    tree
    jq

    lm_sensors
    nvtopPackages.amd
    nethogs
    powertop
    fastfetch
  ];
}
