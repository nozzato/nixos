{ ... }: {
  imports = [
    ./nix.nix
    ./home-manager.nix
    ./hardware.nix
    ./user.nix
    ./shell.nix
    ./networking.nix
    ./locale.nix
    ./openssh.nix
  ];
}
