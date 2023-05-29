{ config, lib, pkgs, ... }: {
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" ];
  };
  programs.gpg = {
    enable = true;
  };
  programs.ssh = {
    enable = true;
    userKnownHostsFile = "~/.ssh/known_hosts " + toString ../config/ssh/known_hosts;
  };
}