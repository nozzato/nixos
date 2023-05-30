#!/usr/bin/env bash

if [ ! -f /tmp/rgb-toggle ]; then
  touch /tmp/rgb-toggle
  openrgb -p on
else
  rm /tmp/rgb-toggle
  openrgb -p off
fi