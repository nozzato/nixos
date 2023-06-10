{ config, lib, pkgs, ... }: {
  users.users.noah = {
    isNormalUser = true;
    description = "Noah Torrance";
    useDefaultShell = true;
  };
  networking.hostName = "nozzlap";

  time.timeZone = "Europe/London";

  imports = [
    ./filesystems.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    ./units.nix
  ];
}
