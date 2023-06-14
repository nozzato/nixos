{ config, lib, pkgs, ... }: {
  services.printing = {
    enable = true;
  };
  programs.system-config-printer.enable = true;
}
