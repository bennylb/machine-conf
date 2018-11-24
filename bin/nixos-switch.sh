#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo "Must be run as root."
    exit 1
fi

NXPKGS_REPO="$HOME/src/git/nixpkgs"
NXPKGS_STATUS="$(cd $NXPKGS_REPO && git status -b --porcelain=v2)"
NXPKGS_BRANCH="$(echo "$NXPKGS_STATUS" | awk '/head/ { print $3 }')"

echo -e "Current nixpkgs branch is: $NXPKGS_BRANCH.\n"

read -p "Is this the correct branch to rebuild the system? [Y/n]: " -n 1 -r
echo -e "\n"
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

exec nixos-rebuild -I nixpkgs="$NXPKGS_REPO" switch
