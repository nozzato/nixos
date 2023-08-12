{ config, lib, pkgs, ... }: {
  programs.steam.enable = true;

  services.xserver.desktopManager.retroarch.enable = true;
  environment.systemPackages = with pkgs; [
    (retroarch.override {
      cores = with libretro; [
        pcsx2
      ];
    })
  ];
}
