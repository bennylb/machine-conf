# If not on nixos
# OS_ID=`sed -n 's/^ID=//p' /etc/os-release`
# if [[ "$OS_ID" != "nixos" ]]; then echo true; fi

# Use gpg-agent as ssh-agent
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

unset SSH_AGENT_PID
if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi
