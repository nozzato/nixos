{ config, lib, pkgs, ... }: {
  console.keyMap = "uk";

  services.gpm.enable = true;
}