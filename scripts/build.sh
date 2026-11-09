#!/usr/bin/env bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null

git add --update
case "$(uname -s)" in
  "Linux")
    nixos-rebuild switch --sudo --flake ../ --show-trace
    ;;
  "Darwin")
    sudo darwin-rebuild switch --flake ../ --show-trace
    ;;
  *)
    echo "Unrecognised value for uname -s"
    exit 1
    ;;
esac
