{ inputs, config, ... }: {
  imports = [
    inputs.vscode-server.homeModules.default
  ];

  services.vscode-server = {
    enable = true;
    installPath = "${config.home.homeDirectory}/.vscodium-server";
  };
}
