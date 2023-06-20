{ config, lib, pkgs, self, system, ... }: {
  home.packages = with self.inputs; [
    grsync.packages.${system}.grsync
  ];
}
