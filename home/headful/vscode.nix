{ config, lib, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # Formatter
      esbenp.prettier-vscode

      # Web
      bradlc.vscode-tailwindcss

      # Nix
      jnoortheen.nix-ide
      mkhl.direnv
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Web
      {
        publisher = "Vue";
        name = "volar";
        version = "1.8.11";
        sha256 = "sha256-Y3vhArpoXCGHs/A47716XBkbtGKv6koepZtm/ukY7k8=";
      }
      {
        publisher = "Vue";
        name = "vscode-typescript-vue-plugin";
        version = "1.8.11";
        sha256 = "sha256-ubvSDztn0cYNMyh+Cm7l48N6wn1Zt6LWpnw869idg7o=";
      }
    ];
    userSettings = {
      css = {
        validate = false;
      };
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
        quickSuggestions = {
          strings = true;
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
      tailwindCSS = {
        includeLanguages = {
          vue = "html";
          vue-html = "html";
        };
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
