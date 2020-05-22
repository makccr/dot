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
alias vi='nvim'
alias vf='ranger'
alias tty='tty-clock -C4 -c'
alias todo='cat ~/Dropbox/writing/notes/To-do.md'
alias todoe='nvim ~/Dropbox/writing/notes/To-do.md'
alias commit='git add -A; git commit -m'
alias reset='cd ~; clear; source ~/.config/zsh/.zprofile'
alias vol4='cd ~/Dropbox/writing/journal; nvim volume-4.md'
alias pac='sudo pacman'
alias s='startx'
alias wall='nitrogen --set-zoom-fill --random ~/Media/wallpapers/backgrounds'
alias ddate='date +"%R - %a, %B %d, %Y"'

# Prompt Settings
PROMPT='%F{blue}%2~%f %B%F{cyan}∳%f%b '

# Git Prompt Settings
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%r%f'
zstyle ':vcs_info:*' enable git

#||\\ //||
#|| \// || Mackenzie Criswell
#|| //\ || https://makc.co
#||   \\|| https://github.com/makccr
