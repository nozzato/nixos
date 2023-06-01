#!/usr/bin/env bash

workspace=$(hyprctl activeworkspace -j | jq -c '.id')

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
    alacritty --class ncmpcpp -e ncmpcpp
  ;;
esac