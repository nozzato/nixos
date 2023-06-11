{ config, lib, pkgs, self, system, ... }: {
  environment.systemPackages = [
    self.inputs.nix-alien.packages.${system}.nix-alien
    self.inputs.nixgl.packages.${system}.nixGLDefault
  ];
  programs.nix-ld.enable = true;
}
