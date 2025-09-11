# Basic stff
source ~/.config/zsh/.zprofile #.zshenv stuff
export TERM="xterm-256color"
export HISTFILE=~/.config/zsh/.zsh_history

export EDITOR='nvim'
export TERMINAL='alacritty'
export BROWSER='google-chrome-stable'
export MANPAGER='nvim +Man!'

# Basic zsh settings
PATH=$PATH:$HOME/.scripts #making my scripts run without typing the whole path

bindkey -v # vi-mode
autoload -Uz compinit && compinit #need the next two lines for case insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Prompt Settings
declare -a PROMPTS
PROMPTS=(
    "∮"
    "∯"
    "≎"
    ""
)
RANDOM=$$$(date +%s)
ignition=${PROMPTS[$RANDOM % ${#RANDOM[*]}+1]}
PROMPT='%F{yellow}%1~%f %F{green}$ignition%f '

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
alias pvpn='protonvpn-cli'
alias s='startx'
alias v='nvim'
alias f='ranger'
alias t='btop'
alias tty='tty-clock -C1 -c'
alias pac='sudo pacman'
alias commit='git add -A; git commit -m'
alias weather='clear && curl wttr.in'
alias shot='flameshot gui'
alias kill='killall -q'
alias suck='rm -f config.h ; sudo make install'
alias wal='feh --bg-fill -z'
alias script='node awc.js'
alias lock='xscreensaver-command -lock'
alias handbrake='ghb'
alias visudo='EDITOR=nvim visudo'

alias win='cd /mnt/c/Users/macke'

alias ls='lsd'
alias cat='bat'
alias drive='ranger /run/media/makc/'

## Terminal maintenance
alias rec='gpg --recv-keys --keyserver hkp://pgp.mit.edu'
alias todo="clear; echo -e '\033[1mTo-do\033[0m'; echo '--------------'; bat -p Dropbox/writing/notes/todo.md"
alias todoe='nvim ~/Dropbox/writing/notes/todo.md'
alias reset='clear; source ~/.config/zsh/.zshrc'
alias fetch='clear && neofetch && fortune ~/.scripts/quotes/quotes'

## Journal launching aliases
alias j='date +"%R - %a, %B %d, %Y" | xclip -select clipboard'

## Snippets
alias ddate='date +"%R - %a, %B %d, %Y" | xclip -select clipboard && date +"%R - %a, %B %d, %Y"' 
alias dday='date +"%Y.%m.%d - " | xclip -select clipboard ; date +"%Y.%m.%d"'
