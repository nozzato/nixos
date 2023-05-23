{ pkgs, lib, config, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    recommendedEnvironment = true;
    xwayland.enable = true;
    nvidiaPatches = false;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  programs.alacritty.enable = true;
}
