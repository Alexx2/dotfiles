# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/alexandre/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

zsh $HOME/temas/base16-builder/output/shell/base16-brown.dark.sh
