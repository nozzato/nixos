{ ... }: {
  imports = [
    ./nix.nix
    ./hardware.nix
    ./user.nix
    ./shell.nix
    ./networking.nix
    ./locale.nix
    ./openssh.nix
  ];
}
