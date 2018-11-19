# antigen config
antigen use oh-my-zsh

antigen bundle common-aliases
antigen bundle git
antigen bundle colored-man-pages
antigen bundle ~/machine-conf/example-nix/tools/oh-my-zsh/plugins/direnv
# antigen bundle mafredri/zsh-async
# antigen bundle sindresorhus/pure
# antigen bundle ~/src/git/pure@prompt/+direnv
# antigen bundle ~/src/git/pure --branch=prompt/+direnv

# antigen theme ~/machine-conf/example-nix/tools/oh-my-zsh/themes
# antigen theme refined

antigen apply

fpath=( "$HOME/.local/share/zsh/site-functions" $fpath )

autoload -Uz promptinit; promptinit
prompt pure

emulate sh -c 'source ~/.commonrc.sh'
