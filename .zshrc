# --------------------- Basic zsh setting & themes----------------------------
export ZSH="/Users/makc/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
bindkey -v #Enables Vim Mode in z-shell

# -------------------------- Setting up Defaults -----------------------------
export EDITOR='nvim'
export TERMINAL='alacritty'
export BROWSER='firefox'

# ------------------------ Adding $PATH Directory ----------------------------
PATH=$PATH:$HOME/.bin

# -------------------------------- Aliases -----------------------------------
alias tsm='transmission-remote -l'
alias v='nvim'
alias vf='vifm ~/'
alias tty='tty-clock -C4 -c'
alias t='tty -t'
alias s='spotify'
alias todo='cat ~/Dropbox/writing/notes/To-do.md'
alias todoe='nvim ~/Dropbox/writing/notes/To-do.md'
# Snippet type aliases 
alias commit='git add -A; git commit -m'
alias reset='clear; source ~/.zprofile'
alias vol4='cd ~/Dropbox/writing/journal; nvim volume-4.md'


# ||\\ //|| 
# || \// || Mackenzie Criswell
# || //\ || https://makc.co
# ||   \\|| https://github.com/makccr
