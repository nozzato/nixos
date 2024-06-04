{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index

    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    validateSopsFiles = false;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  systemd.user.startServices = "sd-switch";
  services.home-manager.autoUpgrade = {
    enable = inputs.self ? rev;
    frequency = "16:20";
  };
  systemd.user.services.home-manager-auto-upgrade = lib.mkForce {
    Unit.Description = "Home Manager upgrade";
    Service.ExecStart = toString (pkgs.writeShellScript "home-manager-auto-upgrade" ''
      echo "Upgrade Home Manager"
      ${pkgs.home-manager}/bin/home-manager switch --flake ${inputs.self.outPath}
    '');
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
    sops
    age
    ssh-to-age

    gocryptfs
    p7zip
    trash-cli
    wget
    inetutils

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
