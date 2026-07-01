export LANG=en_US.UTF-8
export LC_ALL=$LANG

export PATH=$PATH:~/.local/share/nvim/mason/bin:/usr/local/nnn

# source ~/.nnnrc


# auto install zinit to manage zsh plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -a $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

(( $+aliases[zi] )) && unalias zi

eval "$(zoxide init zsh)"

# eval "$(zellij setup --generate-auto-start zsh)"

# add zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

# fix fzf-tab bug
# BUG: command not found:_complete
zicompinit; zicdreplay
zinit light Aloxaf/fzf-tab

# vi mode like in zsh
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# change to vi mode
bindkey -v

# 啟用 terminfo
zmodload zsh/terminfo

# bind zsh-history-substring-search keybinding

# 1. 用 terminfo 綁 arrow keys，支援 emacs / viins map
if [[ -n "$terminfo[kcuu1]" ]]; then
  bindkey -M emacs "$terminfo[kcuu1]" history-substring-search-up
  bindkey -M viins "$terminfo[kcuu1]" history-substring-search-up
fi

if [[ -n "$terminfo[kcud1]" ]]; then
  bindkey -M emacs "$terminfo[kcud1]" history-substring-search-down
  bindkey -M viins "$terminfo[kcud1]" history-substring-search-down
fi

# 2. 額外 fallback：直接綁常見 ANSI 序列（↑↓）
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# 3. vi 命令模式下用 j/k
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# 只下載 starship 二進位
zinit ice as"command" from"gh-r"
zinit light starship/starship

# 在整個 config 中唯一一次 init
if ! typeset -f starship_zle-keymap-select-wrapped >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/can-utils/bin:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
