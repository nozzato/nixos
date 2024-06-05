{ inputs, lib, config, pkgs, ... }: {
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
  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "05:10";
  };
  systemd.user.services.home-manager-auto-upgrade.Service = {
    Environment = let
      packages = with pkgs; [
        nix
        home-manager
        git
      ];
      paths = builtins.concatStringsSep ":" (map (pkg: "${pkgs.lib.getBin pkg}/bin") packages);
    in ''"PATH=${paths}"'';
    ExecStart = let
      updateInputArgs = lib.concatMap (n: ["--update-input" "${n}"]) (
        lib.filter (n: n != "self") (lib.attrNames inputs)
      );
    in lib.mkForce (toString (pkgs.writeShellScript "home-manager-auto-upgrade" ''
      echo "Upgrade Home Manager"
      home-manager switch --flake github:nozzato/nixos ${lib.concatStringsSep " " updateInputArgs} --no-write-lock-file --print-build-logs
    ''));
    TimeoutStartSec = 900;
  };
  systemd.user.timers.home-manager-auto-upgrade.Timer.RandomizedDelaySec = 1800;

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
