 " 基礎設置
lua require('basic')

" lazy插件管理
lua require('plugins')

" 狀態欄插件設定
lua require('plugin-config/lualine')

" tab 頁相關設定
lua require('plugin-config/bufferline')

" 檔案管理器設定
lua require('plugin-config/neo-tree')

" 語法高亮設定
lua require('plugin-config/treesitter')

" 模糊搜尋相關設定
lua require('plugin-config/telescope')

" LSP UI 美化
lua require('plugin-config/Lspsaga')

" 游標快速移動插件設定
lua require('plugin-config/hop')

" session管理插件
lua require('plugin-config/auto-session')
lua require('plugin-config/session-lens')

" Package Manager for Lsp Servers, Dap Servers, Linters, and formatters
lua require('plugin-config/mason')

" comment plugin
lua require('plugin-config/comment')
lua require('plugin-config/neogen')

" Easy Way to Learn KeyMap
lua require('plugin-config/WhichKey')

" Linter/Formatter plugin
lua require('plugin-config/null-ls')

" Auto Save File
lua require('plugin-config/auto-save')

" For luasnip config
lua require('plugin-config/luasnip')

" LSP Client 相關設定
lua require('lsp/setup')

" nvim-cmp 語法自動補全設定
lua require('lsp/nvim-cmp')

" For file icon support
lua require('plugin-config/web-devicons')

" Run Code Like vscode task
lua require('overseer/setup')

" Code Runner
lua require('plugin-config/sniprun')

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

" mark/tabpage/buffer/colorscheme switcher
lua require("plugin-config/reach")

" ehnance ui for notify/message/cmdline
lua require("plugin-config/noice")

" notification manager
lua require('plugin-config/nvim-notify')

"Diagnostics, references, telescope results, quickfix
lua require("plugin-config/trouble")
