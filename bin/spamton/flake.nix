{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      my-name = "spamton";
      my-buildInputs = with pkgs; [ openjdk8 ];
      my-script = (pkgs.writeScriptBin my-name ''
        #!/usr/bin/env bash

        path=$HOME/app/spamton-linux-shimeji

        if [ -d $path ]; then
          cd $path
        else
          exit 1
        fi

        spawn() {
          if (( $(pgrep -f com.group_finity.mascot.Main | wc -l) < 20 )); then
            export LD_LIBRARY_PATH=${pkgs.openjdk8}/lib/openjdk/jre/lib/amd64
            steam-run ${pkgs.openjdk8}/bin/java -classpath Shimeji.jar -Xmx1000m com.group_finity.mascot.Main -Djava.util.logging.config.file=./conf/logging.properties --module-path /javafx-sdk-11.0.2/lib --add-modules=javafx.controls,javafx.fxml --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
          fi
        }
        kill() {
          if [[ $1 == all ]]; then
            pkill -f com.group_finity.mascot.Main
          else
            pkill -fn com.group_finity.mascot.Main
          fi
        }

        if [[ $1 == respawn ]]; then
          kill all
          spawn
        elif [[ $1 == spawn ]]; then
          spawn
        elif [[ $1 == kill ]]; then
          kill
        elif [[ $1 == killall ]]; then
          kill all
        else
          spawn
        fi
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
