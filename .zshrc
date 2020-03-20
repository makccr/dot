# --------------------- Basic zsh setting & themes----------------------------
export ZSH="/Users/makc/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------ Adding $PATH Directory ----------------------------
PATH=$PATH:$HOME/.bin

# -------------------------------- Aliases -----------------------------------

# -------------------------------- Connect -----------------------------------
# https://makc.co
# https://github.com/makccr
