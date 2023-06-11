{ config, lib, pkgs, ... }: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.file-roller.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="block", ENV{ID_FS_LABEL}=="tank", ENV{UDISKS_IGNORE}="1"
  '';
}
