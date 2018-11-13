#!/usr/bin/env sh

if (( $# > 1 )); then
   echo "Wrong number of arguments."
   exit 1
fi

if [[ "$1" == @("enable"|"disable") ]]; then
    xinput "$1" "DLL0665:01 06CB:76AD Touchpad"
else
    echo "Argument must be one of 'enable' or 'disable'."
fi
