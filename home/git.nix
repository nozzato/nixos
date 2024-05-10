{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Noah Torrance";
    userEmail = "noahtorrance27@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}
