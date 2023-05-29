{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "noahtorrance27@gmail.com";
    userName = "Noah Torrance";
    signing = {
      key = "${config.home.homeDirectory}/.ssh/github.com.pub";
      signByDefault = true;
    };
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        ff = "only";
      };
      push = {
        autoSetupRemote = true;
      };
    };
    aliases = {
      clone-all = "clone --recurse-submodules";
      pull-all = "pull --recurse-submodules";
      pull-force = "!git reset --hard HEAD && git pull";
      push-force = "push --force";
    };
    lfs.enable = true;
  };
}