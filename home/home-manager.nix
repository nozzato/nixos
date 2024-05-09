{
  config,
  ...
}: {
  programs.home-manager.enable = true;

  home = {
    stateVersion = "23.11";
    username = "noah";
    homeDirectory = "/home/${config.home.username}";
  };

  systemd.user.startServices = "sd-switch";
}
