{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  system.stateVersion = "23.11";

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };

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

  programs.git.enable = true;

  hardware.enableRedistributableFirmware = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/68853943-689a-48a8-b912-9f3f45ed6e15";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/68A8-95CB";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    "/media/windows" = {
      label = "windows";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=100" "dmask=022" "fmask=033" ];
    };
    "/media/share" = {
      label = "share";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=100" "dmask=022" "fmask=033" ];
    };
    "/media/nozbox" = {
      device = "//192.168.1.6/noah";
      fsType = "cifs";
      options = ["x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/etc/nixos/smb-secrets,uid=1000,gid=100,dir_mode=0700,file_mode=0700"];
    };
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16384;
  }];

  users.users = {
    noah = {
      isNormalUser = true;
      description = "Noah Torrance";
      shell = pkgs.fish;
      extraGroups = let
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

  networking = {
    hostName = "nozdesk";
    interfaces."enp39s0" = {
      ipv4.addresses = [{
        address = "192.168.1.3";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.1.254";
    nameservers = [ "192.168.1.254" ];
    networkmanager.enable = true;
  };

  console.keyMap = "uk";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "C.UTF-8";
      LC_NAME = "C.UTF-8";
    };
  };
  time.timeZone = "Europe/London";

  programs.fish.enable = true;

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
  };
  system.activationScripts.makeSddmKcminputrc = lib.stringAfter [ "var" ] ''
    cat << EOF > /var/lib/sddm/.config/kcminputrc
    [Keyboard]
    NumLock=0

    [Libinput][1241][41119][E-Signal USB Gaming Mouse]
    PointerAcceleration=0.2
    PointerAccelerationProfile=1

    [Mouse]
    X11LibInputXAccelProfileFlat=true
    EOF
  '';
  services.desktopManager.plasma6.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  services.syncthing = {
    enable = true;
    user = "noah";
    dataDir = "/home/noah/sync";
    configDir = "/home/noah/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      options = {
        urAccepted = -1;
      };
      devices = {
        "nozbox" = { id = "BVC35LK-YROXVMS-SMWLNUS-DYKEFWM-ADO4TKJ-5JYHHIR-LLOAW72-BOLYZAR"; };
      };
      folders = {
        "nozbox-noah" = {
          path = "~/sync/nozbox";
          devices = [ "nozbox" ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "2592000";
            };
          };
        };
      };
    };
  };

  systemd.nspawn.active-archlinux = {
    filesConfig = {
      Bind = [
        "/dev/dri"
        "/dev/kfd"
      ];
      TemporaryFileSystem = "/tmp:size=100%";
    };
    execConfig = {
      PrivateUsers = false;
    };
    networkConfig = {
      Private = false;
    };
  };
  system.activationScripts.linkActiveArchlinux = lib.stringAfter [ "var" ] ''
    ln -fs /media/active-linux/machines/active-archlinux /var/lib/machines/active-archlinux
  '';
}
