#!/usr/bin/env bash

workspace=$(hyprctl activeworkspace -j | jq -c '.id')

if [[ -z $1 ]]; then
  case $workspace in
    7)
      steam
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
