# Basic zsh setting & themes
bindkey -v #Enables Vim Mode in z-shell
#export PS1="> "
autoload -Uz promptinit
promptinit
prompt adam2

# Setting up Defaults
export EDITOR='nvim'
export TERMINAL='alacritty'
export BROWSER='firefox'

# Adding $PATH Directory
PATH=$PATH:$HOME/.bin

# Aliases
alias tsm='transmission-remote -l'
alias v='nvim'
alias vim='nvim'
alias vf='vifm .'
alias tty='tty-clock -C4 -c'
alias t='tty -t'
alias s='spotify'
alias todo='cat ~/Dropbox/writing/notes/To-do.md'
alias todoe='nvim ~/Dropbox/writing/notes/To-do.md'
alias commit='git add -A; git commit -m'
alias reset='cd ~; clear; source ~/.zprofile'
alias vol4='cd ~/Dropbox/writing/journal; nvim volume-4.md'

# ||\\ //||
# || \// || Mackenzie Criswell
# || //\ || https://makc.co
# ||   \\|| https://github.com/makccr

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
