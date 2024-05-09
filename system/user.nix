{
  config,
  pkgs,
  ...
}: {
  users.users = {
    noah = {
      isNormalUser = true;
      description = "Noah Torrance";
      shell = pkgs.fish;
      extraGroups = let
        # Snippet from https://github.com/Misterio77/nix-config/blob/main/flake.nix
        ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
      in [
        "wheel"
        "video"
        "audio"
        "network"
      ] ++ ifTheyExist [
        "syncthing"
      ];
    };
  };
}
