{ config, lib, pkgs, self, system, ... }: {
  environment.systemPackages = [
    self.inputs.nix-alien.packages.${system}.nix-alien
  ];
  programs.nix-ld.enable = true;
}