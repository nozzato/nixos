{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    (writeShellScriptBin "dwa" ''
      workspace=$(hyprctl activeworkspace -j | jq -c '.id')

      if [[ -z $1 ]]; then
        case $workspace in
          7)
            steam -console
          ;;
          8)
            discord
          ;;
          9)
            thunderbird
          ;;
          10)
            ymuse
          ;;
        esac
      elif [[ $1 == "-a" ]]; then
        case $workspace in
          7)
            heroic
          ;;
          8)
            whatsapp-for-linux
          ;;
          9)
            thunderbird
          ;;
          10)
            ymuse
          ;;
        esac
      fi
    '')
    (writeShellScriptBin "rgb" ''
      if [[ $1 == on ]]; then
        touch /tmp/rgb.lock
        openrgb -p on
      elif [[ $1 == off ]]; then
        rm /tmp/rgb.lock
        openrgb -p off
      elif [[ $1 == toggle ]]; then
        if [ ! -f /tmp/rgb.lock ]; then
          touch /tmp/rgb.lock
          openrgb -p on
        else
          rm /tmp/rgb.lock
          openrgb -p off
        fi
      fi
    '')
  ];
}
