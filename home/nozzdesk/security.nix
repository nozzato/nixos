{ config, lib, pkgs, ... }: {
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };
  programs.gpg.enable = true;
}