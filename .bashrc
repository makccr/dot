# Basic bash setting & themes
PATH=$PATH:$HOME/.bin
set -o vi
bind 'set completion-ignore-case on'
shopt -s cdspell
complete -d cd

# Prompt Settings
PS1="\e[1;34m";
PS1+="\W ";
PS1+="\e[1;32m";
PS1+="∳ ";
PS1+="\e[0m";
export PS1;

# Setting up Defaults
export EDITOR='nvim'
export TERMINAL='alacritty'
export BROWSER='firefox'

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
alias reset='cd ~; clear; source ~/.profile'
alias vol4='cd ~/Dropbox/writing/journal; nvim volume-4.md'

# ||\\ //||
# || \// || Mackenzie Criswell
# || //\ || https://makc.co
# ||   \\|| https://github.com/makccr
