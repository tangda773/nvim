-- vim.cmd[[colorscheme dracula]]
--
-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"
-- jk移動时光標下上方保留8行
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
-- 使用相對行號
vim.wo.number = true
vim.wo.relativenumber = true
-- 高亮所在行
vim.wo.cursorline = true
-- 顯示左側圖標指示列
vim.wo.signcolumn = "yes"
-- 右側参考線，超過表示代碼太長了，考慮换行
vim.wo.colorcolumn = "80"
-- 縮進2個空格等於一個Tab
vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
-- >> << 时移動長度
vim.o.shiftwidth = 2
vim.bo.shiftwidth = 2
-- 新行對齊當前行，空格替代tab
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
-- 搜索大小寫不敏感，除非包含大寫
vim.o.ignorecase = true
vim.o.smartcase = true
-- 搜索不要高亮
vim.o.hlsearch = false
-- 邊输入邊搜索
vim.o.incsearch = true
-- 使用增强状態欄后不再需要 vim 的模式提示
vim.o.showmode = false
-- 命令行高為2，提供足夠的顯示空間
vim.o.cmdheight = 2
-- 當文件被外部程序修改时，自動加载
vim.o.autoread = true
vim.bo.autoread = true
-- 禁止折行
vim.o.wrap = false
vim.wo.wrap = false
-- 行结尾可以跳到下一行
vim.o.whichwrap = "b,s,<,>,[,],h,l"
-- 允許隐藏被修改过的buffer
vim.o.hidden = true
-- 鼠標支持
vim.o.mouse = "a"
-- 禁止創建備份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
-- smaller updatetime
vim.o.updatetime = 300
-- 设置 timeoutlen 為等待键盤快捷键連擊時間200毫秒，可根據需要设置
-- 遇到問題詳見：https://github.com/nshen/learn-neovim-lua/issues/1
vim.o.timeoutlen = 200
-- split window 從下邊和右邊出現
vim.o.splitbelow = true
vim.o.splitright = true
-- 自動補全不自動選中
vim.g.completeopt = "menu,menuone,noselect,noinsert"
-- 樣式
vim.o.background = "dark"
vim.o.termguicolors = true
vim.opt.termguicolors = true
-- 不可見字符的顯示，這裡只把空格顯示為一個點
vim.o.list = true
vim.o.listchars = "space:·"
-- 補全增强
vim.o.wildmenu = true
-- Dont' pass messages to |ins-completin menu|
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.pumheight = 10
-- always show tabline
vim.o.showtabline = 2
-- enable copy between clipboard and terminals
vim.opt.clipboard = "unnamedplus"
-- 禁用neovim內置插件
-- netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- matchit
-- vim.g.loaded_matchit = 1
--
-- matchparen
vim.g.loaded_matchparen = 1
-- 2html
vim.g.loaded_2html_plugin = 1
-- logiPat
vim.g.loaded_logiPat = 1
-- rrhelper
vim.g.loaded_rrhelper = 1
-- tarPlugin
vim.g.loaded_tarPlugin = 1
-- gzip
vim.g.loaded_gzip = 1
-- zipPlugin
vim.g.loaded_zipPlugin = 1
-- tutor_mode
vim.g.loaded_tutor_mode_plugin = 1
-- rplugin
vim.g.loaded_rplugin = 1
-- spellfile
vim.g.loaded_spellfile_plugin = 1
-- vimball
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
-- getscript
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
-- man
vim.g.loaded_man = 1
