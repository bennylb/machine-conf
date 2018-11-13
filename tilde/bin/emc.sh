#!/usr/bin/env sh

ES_SOCK="/tmp/emacs1000/server"
EM_CLIENT="/run/current-system/sw/bin/emacsclient"

$EM_CLIENT -n -c -a "" --socket-name=$ES_SOCK "$@"
