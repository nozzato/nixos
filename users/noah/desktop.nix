{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    recommendedEnvironment = true;
    xwayland.enable = true;
    nvidiaPatches = false;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
  programs.wofi = {
    enable = true;
  };
  programs.wlogout = {
    enable = true;
  };
  programs.alacritty = {
    enable = true;
  };
  programs.librewolf = {
    enable = true;
  };
}
