export PATH=$PATH:~/.local/share/nvim/mason/bin:/usr/local/nnn

source ~/.nnnrc

eval "$(jump shell)"

eval "$(zoxide init zsh)"

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
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

# vi mode like in zsh
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# enable zsh-history-substring-search
plugins=(zsh-history-substring-search)
# bind zsh-history-substring-search keybinding
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Load starship theme
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

