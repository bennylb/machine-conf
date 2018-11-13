#!/usr/bin/env sh

if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

exec /run/current-system/sw/bin/emacsclient "$@"
