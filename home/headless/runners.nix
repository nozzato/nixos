{ config, lib, pkgs, self, system, ... }: {
  home.packages = with pkgs; with self.inputs; [
    appimage-run
    nix-alien.packages.${system}.nix-alien
    nixgl.packages.${system}.nixGLDefault
  ];
}
