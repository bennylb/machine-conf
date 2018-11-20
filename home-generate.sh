#!/usr/bin/env sh

if which home-manager; then
    if ! test -d ~/.config/nixpkgs; then
        mkdir -p ~/.config/nixpkgs
    fi
    ln -s ./config/nixpkgs/home.nix ~/.config/nixpkgs/home.nix
    home-manager switch
else
    echo "home-manager doesn't seem to be installed."
    echo "Install the system first to make home-manager available."
    exit 1
fi
