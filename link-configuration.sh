#!/usr/bin/env sh

if [ "$EUID" -eq 0 ]; then
    if test -e /etc/nixos/configuration.nix; then
        cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
        rm -f /etc/nixos/configuration.nix
    fi
    ln -s ./sputnik.nix /etc/nixos/configuration.nix
else
    echo "Must be run as root."
    exit 1
fi
