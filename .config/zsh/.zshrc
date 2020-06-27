source ~/.config/zsh/.zprofile

# Basic zsh setting & themes
PATH=$PATH:$HOME/.bin
setopt no_list_ambiguous
bindkey -v

# Setting up Defaults
export EDITOR='nvim'
export TERMINAL='alacritty'
export BROWSER='firefox'

# Prompt Settings
PROMPT='%F{blue}%1~%f %F{cyan}∳%f '
## Git Settings
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%r%f'
zstyle ':vcs_info:*' enable git

# Aliases
## App launchers
alias tsm='transmission-remote'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias f='ranger'
alias tty='tty-clock -C7 -c -t'
alias s='startx'
alias pac='sudo pacman'
alias commit='git add -A; git commit -m'
alias weather='clear && curl wttr.in'
## Terminal maintenance
alias todo='cat ~/Dropbox/writing/notes/To-do.md'
alias todoe='nvim ~/Dropbox/writing/notes/To-do.md'
alias reset='cd ~; clear; source ~/.config/zsh/.zprofile'
alias fetch='clear && neofetch && fortune ~/.bin/quotes/quotes'
## Changing Settings
alias w='feh --bg-fill --randomize ~/Media/wallpapers/backgrounds'
alias hdmi='xrandr --output HDMI1 --mode 1920x960_60.00'
alias vga='xrandr --output VGA1 --mode 1920x960_60.00'
## Journal launching aliases
alias v1='date +"%R - %a, %B %d, %Y" | xclip -select clipboard; cd ~/Dropbox/writing/journal; nvim volume-1.md'
alias v2='date +"%R - %a, %B %d, %Y" | xclip -select clipboard; cd ~/Dropbox/writing/journal; nvim volume-2.md'
alias v3='date +"%R - %a, %B %d, %Y" | xclip -select clipboard; cd ~/Dropbox/writing/journal; nvim volume-3.md'
alias v4='date +"%R - %a, %B %d, %Y" | xclip -select clipboard; cd ~/Dropbox/writing/journal; nvim volume-4.md'
alias v5='date +"%R - %a, %B %d, %Y" | xclip -select clipboard; cd ~/Dropbox/writing/journal; nvim volume-5.md'
## Snippets
alias ddate='date +"%R - %a, %B %d, %Y"'

#||\\ //||
#|| \// || Mackenzie Criswell
#|| //\ || https://makc.co
#||   \\|| https://github.com/makccr
