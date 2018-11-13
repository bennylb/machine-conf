#!/usr/bin/env sh

ES_SOCK="/tmp/emacs1000/server"
EC_BIN="/home/ben/bin/emc-wrap"

if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

$EC_BIN -n -c -a "" --socket-name=$ES_SOCK "$@"
