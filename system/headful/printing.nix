{ config, lib, pkgs, ... }: {
  services.printing = {
    enable = true;
    cups-pdf.enable = true;
  };
  programs.system-config-printer.enable = true;
}
