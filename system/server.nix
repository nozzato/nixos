{ inputs, lib, config, pkgs, ... }: {
  system.autoUpgrade = {
    enable = true;
    dates = "09:05";
    flake = inputs.self.outPath;
    flags = let
      updateInputArgs = lib.concatMap (n: ["--update-input" "${n}"]) (
        lib.filter (n: n != "self") (lib.attrNames inputs)
      );
    in updateInputArgs ++ [
      "--no-write-lock-file"
      "--print-build-logs"
    ];
  };
  systemd.services.nixos-upgrade = {
    serviceConfig = {
      TimeoutStartSec = 900;
    };
    script = lib.mkBefore ''
      cd ${config.users.users.noah.home}/.config/nixos
      ${pkgs.sudo}/bin/sudo -u noah ${pkgs.bash}/bin/bash .envrc
    '';
  };
  systemd.timers.nixos-upgrade = {
    timerConfig = {
      Persistent = lib.mkForce false;
    };
  };
}
