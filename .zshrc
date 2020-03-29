# --------------------- Basic zsh setting & themes----------------------------
export ZSH="/Users/makc/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -------------------------- Setting up Defaults -----------------------------
export EDITOR=/usr/local/bin/nvim

# ------------------------ Adding $PATH Directory ----------------------------
PATH=$PATH:$HOME/.bin

# -------------------------------- Aliases -----------------------------------
alias tsm='transmission-remote -l'
alias v='nvim'

# -------------------------------- Connect -----------------------------------
# https://makc.co
# https://github.com/makccr
