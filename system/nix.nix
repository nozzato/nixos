{
  inputs,
  config,
  lib,
  ...
}: {
  system.stateVersion = "23.11";

  # Snippet from https://github.com/Misterio77/nix-config/blob/main/flake.nix
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  nixpkgs.config.allowUnfree = true;
}
