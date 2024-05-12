{ pkgs, ... }: {
  home.packages = with pkgs; with kdePackages; [
    wl-clipboard

    filelight

    kcharselect
    kcalc

    skanlite
    haruna
  ];
}
