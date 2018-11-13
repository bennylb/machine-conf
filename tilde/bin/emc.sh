#!/usr/bin/env sh

ES_SOCK="/tmp/emacs1000/server"
EM_CLIENT="/run/current-system/sw/bin/emacsclient"

if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

$EM_CLIENT -n -c -a "" --socket-name=$ES_SOCK "$@"
