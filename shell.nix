{ pkgs ? import <nixpkgs> {}, ... }: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
    nativeBuildInputs = with pkgs; [
      home-manager
      git

      sops
      age
      ssh-to-age
    ];
  };
}
