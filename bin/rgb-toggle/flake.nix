{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      my-name = "rgb-toggle";
      my-buildInputs = with pkgs; [ openrgb ];
      my-script = (pkgs.writeScriptBin my-name (builtins.readFile ./rgb-toggle.sh)).overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in rec {
      defaultPackage = packages.rgb-toggle;
      packages.rgb-toggle = pkgs.symlinkJoin {
        name = my-name;
        paths = [ my-script ] ++ my-buildInputs;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
      };
    });
}