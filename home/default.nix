{ ... }: {
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./vim.nix
    ./gocryptfs.nix
  ];
}
