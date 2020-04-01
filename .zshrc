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
alias ls='ls -la'
alias tty='tty-clock -C4 -c'
alias t='tty -t'

# -------------------------------- Connect -----------------------------------
# https://makc.co
# https://github.com/makccr
