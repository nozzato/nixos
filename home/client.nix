{ pkgs, ... }: {
  services.ssh-agent.enable = true;

  home.packages = with pkgs; with kdePackages; [
    wl-clipboard

    filelight
    kcharselect
    kcalc
    skanlite
  ];
}
