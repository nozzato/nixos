{ config, lib, pkgs, ... }: {
  users.users.noah = {
    isNormalUser = true;
    description = "Noah Torrance";
    useDefaultShell = true;
  };
  networking.hostName = "nozlap";

  time.timeZone = "Europe/London";

  imports = [
    ./desktop.nix
    ./filesystems.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    ./units.nix
  ];
}
