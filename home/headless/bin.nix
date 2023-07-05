{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    (writeShellScriptBin "grsync" ''
      new_args=()
      for i in "''${@}"; do
        case "''${i}" in
          /)
            i="/"
          ;;
          */)
            i="''${i%/}"
          ;;
          esac
        new_args+=("''${i}")
      done
      exec rsync "''${new_args[@]}"
    '')
  ];
}
