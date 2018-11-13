# Shell agnostic configuration to be sourced from your shell rc.

# The following emulate as per
# https://unix.stackexchange.com/questions/25243/difference-between-alias-in-zsh-and-alias-in-bash
# but needs some work for intended behaviour.
# emulate -LR sh 2>/dev/null

# TMUX
if which tmux >/dev/null 2>&1; then
    case "$TERM" in
        linux | eterm-color | xterm-kitty)
            true
            ;;
        *)
            test -z "$TMUX" && (tmux attach || tmux new-session)
            ;;
    esac
fi

# if not on nixos
OS_ID=`sed -n 's/^ID=//p' /etc/os-release`

# if [[ "$OS_ID" != "nixos" ]]; then
if [[ true ]]; then
    # Use gpg-agent as ssh-agent
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null

    unset SSH_AGENT_PID
    # if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    #     export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    # fi
    if [ -z "$SSH_AUTH_SOCK" ]; then
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    fi
fi


# Aliases
alias sudo="sudo "
# alias less="less -R"
alias less="bat"
alias fd="fd"
alias du="du -h"
# systemctl
alias sd="systemctl"
alias sdu="systemctl --user"
# Run nix repl and load nixos config
alias nxrc="nix repl '<nixpkgs/nixos>'"
# Run nix repl and load nixos lib
alias nxrl="nix repl '<nixos/lib>'"
alias nxcatpkg="EDITOR=bat nix edit"
# Erase clipster's history
alias clpdh="clipster -c --erase-entire-board"
alias shrld="exec $SHELL -l"
alias saleor="make -f dev-example.Makefile"


# Functions
# Source https://github.com/direnv/direnv/wiki/Nix
nixify() {
    if [ ! -e ./.envrc ]; then
        cat > .envrc <<'EOF'

EOF
        direnv allow
    fi
}

nixify_edit() {
    nixify

    if [ ! -e shell.nix ]; then
        cat > shell.nix <<'EOF'
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    bashInteractive
  ];
}
EOF
        $EDITOR shell.nix
    fi
}
