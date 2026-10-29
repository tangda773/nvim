# ~/.zshrc

setopt interactive_comments

# ==============================================================
# 1. PATH（放最前面，讓後面的工具與 zinit atclone 都找得到）
#    順序與原本相同：越上面優先權越高
# ==============================================================
typeset -U path PATH   # 自動去除重複路徑

export PNPM_HOME="$HOME/.local/share/pnpm"

path=(
  $PNPM_HOME/bin
  $HOME/.local/share/nvim/mason/bin
  $HOME/go/bin
  $HOME/.cargo/bin
  $HOME/.local/bin
  $path
)

# ==============================================================
# 2. 機密資訊（token、API key）放在獨立檔案，不要 commit
#    chmod 600 ~/.zsh/secrets.zsh
# ==============================================================
[[ -f ~/.zsh/secrets.zsh ]] && source ~/.zsh/secrets.zsh

# ==============================================================
# 3. 環境變數
# ==============================================================
export EDITOR=nvim

# fcitx5
export GTK_IM_MODULE=must-not-exists-im-module
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

# ==============================================================
# 4. zinit 自動安裝
# ==============================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# zinit 的 zi alias 會和 zoxide 的 zi 衝突
(( $+aliases[zi] )) && unalias zi

# ==============================================================
# 5. zsh-vi-mode 設定（必須在載入插件「之前」）
# ==============================================================

# 使用 zsh-vi-mode 內建的 surround（s-prefix）
#   Normal：sa" 加、sd" 刪、sr"' 換
#   Visual：S" 加
ZVM_VI_SURROUND_BINDKEY=s-prefix

# Vim-style yank -> 系統剪貼簿 (macOS / Linux / WSL)
function zvm_vi_yank_to_clipboard() {
  zle vi-yank

  local data
  data=$(printf '%s' "$CUTBUFFER")

  case "$(uname -s)" in
    Darwin)
      command -v pbcopy >/dev/null 2>&1 && printf '%s' "$data" | pbcopy
      ;;
    Linux)
      if command -v wl-copy >/dev/null 2>&1; then
        printf '%s' "$data" | wl-copy
      elif command -v xclip >/dev/null 2>&1; then
        printf '%s' "$data" | xclip -selection clipboard
      elif command -v clip.exe >/dev/null 2>&1; then
        printf '%s' "$data" | clip.exe
      fi
      ;;
  esac
}
zle -N zvm_vi_yank_to_clipboard

# zsh-vi-mode 初始化時會重設按鍵，所以自訂綁定要放進它的 hook

# Insert 模式的綁定
function zvm_after_init() {
  zmodload zsh/terminfo

  # ↑↓：history-substring-search
  [[ -n "$terminfo[kcuu1]" ]] && bindkey -M viins "$terminfo[kcuu1]" history-substring-search-up
  [[ -n "$terminfo[kcud1]" ]] && bindkey -M viins "$terminfo[kcud1]" history-substring-search-down
  bindkey -M viins '^[[A' history-substring-search-up
  bindkey -M viins '^[[B' history-substring-search-down

  # Ctrl-R / Ctrl-F：增量歷史搜尋
  bindkey -M viins '^R' history-incremental-search-backward
  bindkey -M viins '^F' history-incremental-search-forward
}

# Normal / Visual 模式的綁定（zsh-vi-mode 預設延遲載入這兩個 keymap）
function zvm_after_lazy_keybindings() {
  # j/k：history-substring-search
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down

  # / 和 ?：Vim-style 歷史搜尋
  bindkey -M vicmd '/' history-incremental-search-forward
  bindkey -M vicmd '?' history-incremental-search-backward

  # y：同時複製到系統剪貼簿
  bindkey -M vicmd  'y' zvm_vi_yank_to_clipboard
  bindkey -M visual 'y' zvm_vi_yank_to_clipboard
}

# ==============================================================
# 6. 插件（順序有意義，不要隨意調換）
# ==============================================================

# vi mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# 補全定義（要在 compinit 之前）
zinit light zsh-users/zsh-completions

# Oh My Zsh 插件
zinit snippet OMZL::git.zsh              # git 插件依賴的函式
zinit snippet OMZL::clipboard.zsh        # copypath 依賴的 clipcopy
zinit snippet OMZP::git                  # gst、gco、gcm、glog 等 git alias
zinit snippet OMZP::extract              # x file.tar.gz 自動解壓
zinit snippet OMZP::colored-man-pages    # man page 上色
zinit snippet OMZP::copypath             # copypath：複製目前路徑
zinit snippet OMZP::command-not-found    # 指令不存在時提示安裝套件

# tuios 補全（要在 compinit 之前）
zinit ice id-as"tuios-completion" as"null" nocompile \
  atclone"tuios completion zsh >| _tuios; zinit creinstall -q .; rm -f \${ZINIT[ZCOMPDUMP_PATH]:-\$HOME/.zcompdump}*" \
  atpull"%atclone" run-atpull
zinit light zdharma-continuum/null

# fnm：下載二進位，並在安裝或更新時產生補全檔（要在 compinit 之前）
zinit ice as"command" from"gh-r" \
  atclone"./fnm completions --shell zsh >| _fnm" \
  atpull"%atclone"
zinit light Schniz/fnm

# 唯一一次 compinit（所有補全都加入之後）
zicompinit; zicdreplay

# fzf-tab：compinit 之後、會包裝 widget 的插件之前
zinit light Aloxaf/fzf-tab

zinit light zsh-users/zsh-autosuggestions

# syntax-highlighting 要在 history-substring-search 之前（官方建議）
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

# ==============================================================
# 7. 工具初始化（需要在 compinit 之後）
# ==============================================================

# fnm 環境（--use-on-cd：進入有 .nvmrc / .node-version 的目錄自動切換版本）
eval "$(fnm env --use-on-cd --version-file-strategy recursive --shell zsh)"

# zoxide（官方建議放在 compinit 之後）
eval "$(zoxide init zsh)"

# starship：只下載二進位
zinit ice as"command" from"gh-r"
zinit light starship/starship

if ! typeset -f starship_zle-keymap-select-wrapped >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ==============================================================
# 8. 終端整合：OSC 133（tuios 的指令區塊標記）
# ==============================================================
autoload -Uz add-zsh-hook
_tuios_osc133_precmd()  { local s=$?; print -n "\e]133;D;$s\a\e]133;A\a"; }
_tuios_osc133_preexec() { print -n "\e]133;C\a"; }
add-zsh-hook precmd  _tuios_osc133_precmd
add-zsh-hook preexec _tuios_osc133_preexec
PS1+=$'%{\e]133;B\a%}'

# ==============================================================
# 9. Alias 與其他設定（放在插件之後，避免被覆蓋）
# ==============================================================
alias ls="lsd"
alias im='fcitx5-remote -t'

source ~/.zsh/zellij.zsh
