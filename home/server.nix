{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.vscode-server.homeModules.default
  ];

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "05:10";
  };
  systemd.user.services.home-manager-auto-upgrade.Service = {
    Environment = let
      packages = with pkgs; [
        nix
        home-manager
        git
      ];
      paths = builtins.concatStringsSep ":" (map (pkg: "${pkgs.lib.getBin pkg}/bin") packages);
    in ''"PATH=${paths}"'';
    ExecStart = let
      updateInputArgs = lib.concatMap (n: ["--update-input" "${n}"]) (
        lib.filter (n: n != "self") (lib.attrNames inputs)
      );
    in lib.mkForce (toString (pkgs.writeShellScript "home-manager-auto-upgrade" ''
      echo "Upgrade Home Manager"
      home-manager switch --flake ${inputs.self.outPath} ${lib.concatStringsSep " " updateInputArgs} --no-write-lock-file --print-build-logs
    ''));
    TimeoutStartSec = 900;
  };
  systemd.user.timers.home-manager-auto-upgrade.Timer.RandomizedDelaySec = 1800;

  services.vscode-server = {
    enable = true;
    installPath = "${config.home.homeDirectory}/.vscodium-server";
  };
}
