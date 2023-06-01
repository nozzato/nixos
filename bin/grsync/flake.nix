{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      my-name = "grsync";
      my-script = (pkgs.writeScriptBin my-name (builtins.readFile ./grsync.sh)).overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in rec {
      defaultPackage = packages.grsync;
      packages.grsync = pkgs.symlinkJoin {
        name = my-name;
        paths = [ my-script ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
      };
    });
}