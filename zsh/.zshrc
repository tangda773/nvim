export PATH=$PATH:~/.local/share/nvim/mason/bin:/usr/local/nnn

source ~/.nnnrc

eval "$(zoxide init zsh)"

eval "$(starship init zsh)"

source /Users/tangda/.config/broot/launcher/bash/br

# auto install zinit to manage zsh plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -a $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# add zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
