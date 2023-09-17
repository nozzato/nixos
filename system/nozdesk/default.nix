{ config, lib, pkgs, ... }: {
  users.users.noah = {
    isNormalUser = true;
    description = "Noah Torrance";
    useDefaultShell = true;
  };
  networking.hostName = "nozdesk";

  time.timeZone = "Europe/London";

  imports = [
    ./filesystems.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./peripherals.nix
    ./printing.nix
    ./units.nix
  ];
}
