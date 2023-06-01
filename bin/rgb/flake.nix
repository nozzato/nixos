{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      my-name = "rgb";
      my-script = (pkgs.writeScriptBin my-name (builtins.readFile ./rgb.sh)).overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in rec {
      defaultPackage = packages.rgb;
      packages.rgb = pkgs.symlinkJoin {
        name = my-name;
        paths = [ my-script ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
      };
    });
}