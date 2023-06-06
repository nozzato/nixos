{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      my-name = "check-battery";
      my-script = (pkgs.writeScriptBin my-name (builtins.readFile ./check-battery.sh)).overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in rec {
      defaultPackage = packages.check-battery;
      packages.check-battery = pkgs.symlinkJoin {
        name = my-name;
        paths = [ my-script ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
      };
    });
}
