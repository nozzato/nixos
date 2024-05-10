{
  pkgs,
  ...
}: {
  programs.htop.enable = true;

  home.packages = with pkgs; [
    nvtopPackages.amd
    nethogs
    powertop
  ];
}
