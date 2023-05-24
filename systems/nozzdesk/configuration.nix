{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  system.stateVersion = "22.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hardware
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
  hardware.opentabletdriver = {
    enable = true;
  };
  hardware.xone = {
    enable = true;
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Kernel
  boot.initrd.kernelModules = [ "amdgpu" ];

  # File systems
  fileSystems = {
    "/media/store" = {
      device = "nozzbox:/box/store";
      fsType = "nfs";
      options = [ "noauto" "user" "_netdev" "bg" ];
    };
    "/media/share" = {
      label = "share";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=033" ];
    };
  };

  swapDevices = [
    {
      label = "swap";
    }
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  # Network
  networking = {
    networkmanager.enable = true;
    hostName = "nozzdesk";
    extraHosts = ''
      192.168.1.134 nozzbox
    '';

    firewall = {
      allowedTCPPorts = [ 22 6600 ];
      allowedUDPPorts = [];
    };
  };

  # Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

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

  # Users
  users.users.noah = {
    isNormalUser = true;
    description = "Noah Torrance";
    extraGroups = [ "input" "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Programs
  nixpkgs.config.allowUnfree = true;

  programs.zsh = {
    enable = true;
  };
}
