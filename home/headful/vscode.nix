{ config, lib, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      jnoortheen.nix-ide
      mkhl.direnv
    ];
    userSettings = {
      diffEditor = {
        renderSideBySide = false;
      };
      editor = {
        fontSize = 13;
        lineDecorationsWidth = 0;
        minimap.enabled = false;
        roundedSelection = false;
        scrollbar.verticalScrollbarSize = 12;
        tabSize = 2;
        wordWrap = "on";
      };
      nix = {
        enableLanguageServer = true;
      };
      workbench = {
        editor.untitled.hint = "hidden";
        startupEditor = "none";
      };
    };
  };
  home.packages = with pkgs; [
    rnix-lsp
  ];
}