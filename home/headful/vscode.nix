{ config, lib, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode

      # Nix
      jnoortheen.nix-ide
      mkhl.direnv

      # Web
      bradlc.vscode-tailwindcss
    ];
    userSettings = {
      diffEditor = {
        renderSideBySide = false;
      };
      editor = {
        defaultFormatter = "esbenp.prettier-vscode";
        fontSize = 13;
        formatOnSave = true;
        lineDecorationsWidth = 0;
        minimap = {
          enabled = false;
        };
        roundedSelection = false;
        scrollbar = {
          verticalScrollbarSize = 12;
        };
        tabSize = 2;
        wordWrap = "on";
      };
      files = {
        insertFinalNewline = true;
      };
      nix = {
        enableLanguageServer = true;
        serverPath = "nil";
      };
      update = {
        mode = "none";
        showReleaseNotes = false;
      };
      workbench = {
        editor = {
          untitled = {
            hint = "hidden";
          };
        };
        startupEditor = "none";
      };
    };
  };
  home.packages = with pkgs; [
    nil
  ];
}
