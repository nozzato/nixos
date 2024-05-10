{
  inputs,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.kate = {
    enable = true;
    editor = {
      tabWidth = 2;
    };
  };
}
