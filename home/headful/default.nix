{ config, lib, pkgs, stylix, ... }: {
  imports = [
    ./beets.nix
    ./bin.nix
    ./creative.nix
    ./desktop.nix
    ./games.nix
    ./keyring.nix
    ./music.nix
    ./sound.nix
    ./terminal.nix
    ./theme.nix
    ./thunar.nix
    ./virtualisation.nix
    ./vscode.nix
    ./web.nix
  ];
}
