{ config, lib, pkgs, self, system, ... }: {
  home.packages = [
    self.inputs.grsync.packages.${system}.grsync
  ];
}