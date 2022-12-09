lua require('impatient')

let g:python3_host_prog="~/scoop/apps/python/current/python"

if exists("g:neovide")
  " Put anying you want to happen only in Neovide
  let g:neovide_transparency=0.8
endif

" neovim theme
colorscheme kanagawa
" If terminal has true colors (24-bits colors)
if has('termguicolors')
  set termguicolors
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

" notification manager
lua require('plugin-config/nvim-notify')

" Package Manager for Lsp Servers, Dap Servers, Linters, and formatters
lua require('plugin-config/mason')

" comment plugin
lua require('plugin-config/comment')

" Easy Way to Learn KeyMap
lua require('plugin-config/WhichKey')

" Linter/Formatter plugin
lua require('plugin-config/null-ls')

" Auto Save File
lua require('plugin-config/auto-save')

" For luasnip config
lua require('plugin-config/luasnip')

" Git 相關設定
lua require('plugin-config/gitsigns')

" Fix Git Conflict
lua require('plugin-config/conflict')

" LSP Client 相關設定
lua require('lsp/setup')

" nvim-cmp 語法自動補全設定
lua require('lsp/nvim-cmp')

" For file icon support
lua require('plugin-config/web-devicons')

" Run Code Like vscode task
lua require('overseer/setup')

" Code Tester
lua require('plugin-config/neotest')

" Terminal
lua require('plugin-config/toggleterm')

" TODO comment setting
lua require('plugin-config/todo')

" Surround plugin
lua require('plugin-config/nvim-surround')

" QuickFix improve
lua require('plugin-config/nvim-bqf')

" autopairs plugin
lua require('plugin-config/nvim-autopairs')

" startup menu config
lua require('plugin-config/alpha')
" disable the tabline when alpha buffer
 autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2

" enable neovim transparent
lua require('plugin-config/transparent')

" mark/tabpage/buffer/colorscheme switcher
lua require('plugin-config/reach')

" ehance ui for notify/message/cmdline
lua require('plugin-config/noice')

" project manager
lua require('plugin-config/projections')

" Session Manager
lua require('plugin-config/persist')
