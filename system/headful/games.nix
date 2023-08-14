{ config, lib, pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  networking.firewall.allowedTCPPorts = [ 24070 ];

  services.xserver.desktopManager.retroarch.enable = true;
  environment.systemPackages = with pkgs; [
    (retroarch.override {
      cores = with libretro; [
        pcsx2
      ];
    })
  ];
}
