{ inputs, lib, config, ... }: {
  imports = [
    inputs.vscode-server.homeModules.default
  ];

  services.vscode-server = {
    enable = true;
    installPath = "${config.home.homeDirectory}/.vscodium-server";
  };
  home.activation.linkVSCodiumServer = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ${config.home.homeDirectory}/.vscode-oss/extensions \
      ${config.home.homeDirectory}/.vscodium-server/
  '';
}
