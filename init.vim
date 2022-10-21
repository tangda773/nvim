" neovim theme
colorscheme kanagawa
" If terminal has true colors (24-bits colors)
if has('termguicolors')
  set termguicolors
endif

if has('nvim') && executable('nvr')
  let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  let g:lazygit_use_neovim_remote = 0
endif

" 基礎設置
lua require('basic')

" packer插件管理
lua require('plugins')

" 狀態欄插件設定
lua require('plugin-config/lualine')

" tab 頁相關設定
lua require('plugin-config/bufferline')

" 檔案管理器設定
lua require('plugin-config/nvim-tree')
" 檔案管理自動關閉
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

" 語法高亮設定
lua require('plugin-config/treesitter')

" 模糊搜尋相關設定
lua require('plugin-config/telescope')

" LSP UI 美化
lua require('plugin-config/Lspsaga')

" 游標快速移動插件設定
lua require('plugin-config/hop')

" session管理插件
lua require('plugin-config/neovim-session-manager')

" LaTeX/Markdown Previewer
lua require('plugin-config/knap')

" notification manager
lua require('plugin-config/nvim-notify')

" function signature
lua require('plugin-config/lsp_signature')

" Package Manager for Lsp Servers, Dap Servers, Linters, and formatters
lua require('plugin-config/mason')

" comment plugin
lua require('plugin-config/comment')

" Easy Way to Learn KeyMap
lua require('plugin-config/WhichKey')

" Lsp Linters
" lua require('plugin-config/nvim-lint')

" Lsp Formatters
" lua require('plugin-config/formatter')

lua require('plugin-config/null-ls')

" Auto Save File
" lua require('plugin-config/auto-save')

" For luasnip config
lua require('plugin-config/luasnip')

" For Rust Progamming
" lua require('plugin-config/rust-tools')

" For Crates Manager
lua require('plugin-config/crates')

" For tmux config
" lua require('plugin-config/tmux')

" Symbols Outline 設定
lua require('plugin-config/symbols-outline')

" Git 相關設定
lua require('plugin-config/lazygit')
lua require('plugin-config/gitsigns')

" nvim-dap 相關設定
lua require('dap/setup')

" LSP Client 相關設定
lua require('lsp/setup')

" nvim-cmp 語法自動補全設定
lua require('lsp/nvim-cmp')

" For dev development
lua require('plugin-config/neodev')

" Project management
lua require('plugin-config/project')

" Code Runner
lua require('plugin-config/toggletasks')

" Terminal
lua require('plugin-config/toggleterm')
