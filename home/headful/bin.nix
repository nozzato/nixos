{ config, lib, pkgs, self, system, ... }: {
  home.packages = with self.inputs; [
    dwa.packages.${system}.dwa
    rgb.packages.${system}.rgb
    spamton.packages.${system}.spamton
  ];
}
