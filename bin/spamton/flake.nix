{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      my-name = "spamton";
      my-buildInputs = with pkgs; [ openjdk8 ];
      my-script = (pkgs.writeScriptBin my-name ''
        #!/usr/bin/env bash

        cd $HOME/app
        git clone https://codeberg.org/thatonecalculator/spamton-linux-shimeji
        cd spamton-linux-shimeji

        export LD_LIBRARY_PATH=${pkgs.openjdk8}/lib/openjdk/jre/lib/amd64
        steam-run ${pkgs.openjdk8}/bin/java -classpath Shimeji.jar -Xmx1000m com.group_finity.mascot.Main -Djava.util.logging.config.file=./conf/logging.properties --module-path /javafx-sdk-11.0.2/lib --add-modules=javafx.controls,javafx.fxml --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
      '').overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in rec {
      defaultPackage = packages.spamton;
      packages.spamton = pkgs.symlinkJoin {
        name = my-name;
        paths = [ my-script ] ++ my-buildInputs;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
      };
    });
}
