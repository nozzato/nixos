{ config, lib, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # Formatter
      esbenp.prettier-vscode

      # Web
      bradlc.vscode-tailwindcss

      # SVG
      jock.svg

      # Nix
      jnoortheen.nix-ide
      mkhl.direnv
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Web
      {
        publisher = "svelte";
        name = "svelte-vscode";
        version = "107.10.1";
        sha256 = "sha256-Tn+SrL6C0SH18BbsdvC1Vjf0CBp1J1jqRzUvFhFBj1A=";
      }
      {
        publisher = "ryanyang52";
        name = "vscode-svelte-snippets";
        version = "0.6.1";
        sha256 = "sha256-xpO6c9rs1F4lXcyYCTXd1b1lI759EH8YmLjij5dYi5A=";
      }
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
      svelte = {
        enable-ts-plugin = true;
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
