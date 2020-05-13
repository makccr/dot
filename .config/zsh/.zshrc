# Basic bash setting & themes
PATH=$PATH:$HOME/.bin
setopt no_list_ambiguous
bindkey -v

# Setting up Defaults
export EDITOR='nvim'
export TERMINAL='alacritty'
export BROWSER='firefox'

# Aliases
alias tsm='transmission-remote'
alias v='nvim'
alias vim='nvim'
alias vf='vifm .'
alias tty='tty-clock -C4 -c'
alias t='tty -t'
alias s='spotify'
alias todo='cat ~/Dropbox/writing/notes/To-do.md'
alias todoe='nvim ~/Dropbox/writing/notes/To-do.md'
alias commit='git add -A; git commit -m'
alias reset='cd ~; clear; source ~/.config/zsh/.zprofile'
alias vol4='cd ~/Dropbox/writing/journal; nvim volume-4.md'

# Prompt Settings
PROMPT='%F{blue}%2~%f %B%F{cyan}∳%f%b '

# ||\\ //||
# || \// || Mackenzie Criswell
# || //\ || https://makc.co
# ||   \\|| https://github.com/makccr
