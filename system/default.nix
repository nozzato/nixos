{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    gnupg = {
      sshKeyPaths = [ ];
    };
  };

  system.stateVersion = "23.11";
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes repl-flake";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
      randomizedDelaySec = "1800";
    };
  };
  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;

  hardware.enableRedistributableFirmware = true;
  services.gpm.enable = true;

  sops.secrets = {
    "system/default/user_noah_password" = {
      neededForUsers = true;
    };
  };
  users.users = {
    noah = {
      isNormalUser = true;
      hashedPasswordFile = lib.mkDefault config.sops.secrets."system/default/user_noah_password".path;
      uid = 1000;
      description = "Noah Torrance";
      extraGroups = let
        ifTheyExist = groups: lib.filter (group: lib.hasAttr group config.users.groups) groups;
      in [
        "wheel"
        "video"
        "audio"
      ] ++ ifTheyExist [
        "networkmanager"
        "syncthing"
        "i2c"
        "adbusers"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIC70YOK3H1kR4RqkCfi4EohFsWgAAXMA3GsFvAuci7e"
      ];
      shell = pkgs.fish;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  programs.ssh = {
    knownHosts = {
      "192.168.1.3".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN25A3Z3vMzMdH0/BIKXkBBAPh8R3r6d01uNkx5qirE4";
      "192.168.1.4".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClIhQD/Kz1TxGrC2oIXzzlO6qbNWX9qNq30457b/DIrcVRgobjKlSwcq88ra3ENzBnofwZM0xYMvCXbOQeCt1sJqVRXzgsA7sJlgvVdyhTAZKSvIX78Amje7mujh5z51WUyJb9OvpyoPSzDOF3qcPYFp6uT/qrQ3h4DcS2rLN6GaryyhoNdITv2Pvw749SmBqW+StUNi+hya/wXtT31RrJwg69P72MetbRMpgm4n+dGOwSJy509oXU4cZn7HIxaZKr0Sm7jhBVnDkQkSgqHuxuuYq/aM0b8PRKnCVWTlZiHG94V9gL24eewIMNoiqtvBUoszmfm6q3AzfponvSloeP";
      "192.168.1.5".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtowgPdBeyhV+EkYVE5JkwBFcGL8LLdawNPrIOlVwdr";

      "github.com".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
  github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=";
    };
    extraConfig = ''
      Host 192.168.1.3
        ForwardAgent yes
      Host 192.168.1.4
        KexAlgorithms +diffie-hellman-group1-sha1
        HostKeyAlgorithms +ssh-rsa
        PubkeyAcceptedKeyTypes +ssh-rsa
      Host 192.168.1.5
        ForwardAgent yes
    '';
  };
  security.pam.sshAgentAuth.enable = true;

  networking.firewall.enable = true;

  sops.secrets = {
    "system/default/tailscale_preauthkey" = { };
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = lib.mkDefault "client";
    authKeyFile = config.sops.secrets."system/default/tailscale_preauthkey".path;
    extraUpFlags = [
      "--login-server=http://localhost:8080"
    ];
  };
  systemd.services.tailscaled-autoconnect = {
    preStart = ''
      ${pkgs.ethtool}/bin/ethtool -K eno1 rx-udp-gro-forwarding on rx-gro-list off
    '';
  };

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

  programs.fish.enable = true;

  programs.vim.defaultEditor = true;

  programs.htop.enable = true;

  environment.systemPackages = with pkgs; [
    exfatprogs
    ntfs3g
  ];
}
