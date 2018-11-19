# antigen config
antigen use oh-my-zsh

antigen bundle common-aliases
antigen bundle git
antigen bundle ~/machine-conf/example-nix/tools/oh-my-zsh/plugins/direnv
antigen bundle mafredri/zsh-async
# antigen bundle sindresorhus/pure
antigen bundle ~/src/git/pure

# antigen theme ~/machine-conf/example-nix/tools/oh-my-zsh/themes
# antigen theme refined

antigen apply

emulate sh -c 'source ~/.commonrc.sh'
# source ~/.commonrc.sh
