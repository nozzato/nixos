{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index

    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    validateSopsFiles = false;
    age = {
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  systemd.user.startServices = "sd-switch";

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
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

  programs.nix-index = {
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.sessionVariables = {
    DIRENV_WARN_TIMEOUT = "90s";
  };

  home.packages = with pkgs; [
    sops
    age
    ssh-to-age

    gptfdisk
    parted
    gocryptfs
    rsync
    rclone
    vimv
    p7zip
    unrar
    trash-cli
    wget
    inetutils

    tmux
    tree
    lsof
    fd
    calc
    jq

    lm_sensors
    nethogs
    powertop
    fastfetch
  ];
}
