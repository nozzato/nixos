{ config, lib, pkgs, ... }: {
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs.ssh.startAgent = true;
}