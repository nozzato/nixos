{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    blender
  ];

  nixpkgs.overlays = [
    (final: prev: {
      blender = prev.blender.override { cudaSupport = true; };
    })
  ];
}
