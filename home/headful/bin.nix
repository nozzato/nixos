{ config, lib, pkgs, self, system, ... }: {
  home.packages = [
    self.inputs.check-battery.packages.${system}.check-battery
    self.inputs.dwa.packages.${system}.dwa
    self.inputs.rgb.packages.${system}.rgb
  ];
}
