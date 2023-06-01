#!/usr/bin/env bash

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