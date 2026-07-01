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

# --- zsh-vi-mode extra: s-prefix surround + history search ---

# 使用 s-prefix surround 操作
export ZVM_VI_SURROUND_BINDKEY=s-prefix

# 使用 Zsh 官方 surround 函式
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

# Normal 模式：s-prefix surround
#   sa  : add-surround
#   sd  : delete-surround
#   sr  : change-surround
bindkey -M vicmd 'sa' add-surround
bindkey -M vicmd 'sd' delete-surround
bindkey -M vicmd 'sr' change-surround

# Visual 模式：用 S 加 surround（典型用法）
bindkey -M visual 'S' add-surround

# Vim-style history search: / and ?
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M vicmd '?' history-incremental-search-backward

# Insert 模式保留 Ctrl-R / Ctrl-F 做增量歷史搜尋
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^F' history-incremental-search-forward

# --- Vim-style yank -> system clipboard (macOS / Linux / WSL) ---

function zvm_vi_yank_to_clipboard() {
  # 先執行原本的 vi yank，照常把內容放進 CUTBUFFER
  zle vi-yank

  # 把 CUTBUFFER 取出一次，避免多次引用
  local data
  data=$(printf '%s' "$CUTBUFFER")

  # 根據平台選擇剪貼板工具
  case "$(uname -s)" in
    Darwin)
      # macOS：pbcopy
      command -v pbcopy >/dev/null 2>&1 && printf '%s' "$data" | pbcopy
      ;;
    Linux)
      # Linux / WSL：優先 wl-copy，其次 xclip，再退回 clip.exe（WSL）
      if command -v wl-copy >/dev/null 2>&1; then
        printf '%s' "$data" | wl-copy
      elif command -v xclip >/dev/null 2>&1; then
        printf '%s' "$data" | xclip -selection clipboard
      elif command -v clip.exe >/dev/null 2>&1; then
        # WSL 上的 Windows 剪貼板
        printf '%s' "$data" | clip.exe
      fi
      ;;
  esac
}

# 宣告這個自訂 widget
zle -N zvm_vi_yank_to_clipboard

# 將 Normal / Visual 模式下的 'y' 綁到這個 wrapper
bindkey -M vicmd 'y' zvm_vi_yank_to_clipboard
bindkey -M visual 'y' zvm_vi_yank_to_clipboard

# 只下載 starship 二進位
zinit ice as"command" from"gh-r"
zinit light starship/starship

# 在整個 config 中唯一一次 init
if ! typeset -f starship_zle-keymap-select-wrapped >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
