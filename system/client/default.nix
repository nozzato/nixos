{ ... }: {
  imports = [
    ./filesystems.nix
    ./syncthing.nix
    ./samba.nix
    ./plasma.nix
    ./sound.nix
    ./bluetooth.nix
    ./printing.nix
    ./ssh-agent.nix
  ];
}
