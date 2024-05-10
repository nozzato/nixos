{
  inputs,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.fish = {
    enable = true;
    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.nix-index.enableFishIntegration = false;
}
