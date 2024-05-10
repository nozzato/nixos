{ ... }: {
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./shell.nix
    ./top.nix
    ./git.nix
    ./ssh.nix
    ./vim.nix
    ./gocryptfs.nix
  ];
}
