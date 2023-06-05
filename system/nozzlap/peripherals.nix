{ config, lib, pkgs, ... }: {
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    light
  ];
}