source ~/.config/zsh/.zprofile

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
alias vi='nvim'
alias vim='nvim'
alias f='ranger'
alias tty='tty-clock -C4 -c'
alias todo='cat ~/Dropbox/writing/notes/To-do.md'
alias todoe='nvim ~/Dropbox/writing/notes/To-do.md'
alias commit='git add -A; git commit -m'
alias reset='cd ~; clear; source ~/.config/zsh/.zprofile'
alias fetch='clear && neofetch && fortune ~/.bin/quotes/quotes'
alias vol1='cd ~/Dropbox/writing/journal; nvim volume-1.md'
alias vol2='cd ~/Dropbox/writing/journal; nvim volume-2.md'
alias vol3='cd ~/Dropbox/writing/journal; nvim volume-3.md'
alias vol4='cd ~/Dropbox/writing/journal; nvim volume-4.md'
alias vol5='cd ~/Dropbox/writing/journal; nvim volume-5.md'
alias pac='sudo pacman'
alias s='startx'
alias w='nitrogen --set-zoom-fill --random ~/Media/wallpapers/backgrounds'
alias ddate='date +"%R - %a, %B %d, %Y"'
alias hdmi='xrandr --output HDMI1 --mode 1920x960_60.00'
alias vga='xrandr --output VGA1 --mode 1920x960_60.00'

# Prompt Settings
PROMPT='%F{blue}%2~%f %F{cyan}∳%f '

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
