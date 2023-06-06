{ config, lib, pkgs, ... }: {
  services.printing.drivers = with pkgs; [
    epson-escpr2
  ];
}
