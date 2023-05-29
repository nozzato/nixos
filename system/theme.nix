{ config, lib, pkgs, ... }: {
  environment.variables = {
    GTK_THEME = "adw-gtk3";
  };
}