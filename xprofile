# Use gpg-agent as ssh-agent
if test -z "$(pidof gpg-agent)"; then
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null

    unset SSH_AGENT_PID
    if [ -z "$SSH_AUTH_SOCK" ]; then
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    fi
fi
