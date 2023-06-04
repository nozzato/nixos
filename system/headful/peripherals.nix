{ config, lib, pkgs, ... }: {
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.opentabletdriver.enable = true;

  hardware.xone.enable = true;

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  environment.systemPackages = with pkgs; [
    light
  ];
}