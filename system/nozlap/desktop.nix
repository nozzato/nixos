{ config, lib, pkgs, ... }: {
  programs.hyprland = {
    nvidiaPatches = true;
  };
}
