-- utf8
vim.opt.fileencoding = "utf-8"

-- 捲動時保留上下左右的上下文行數
vim.opt.scrolloff    = 8
vim.opt.sidescrolloff = 8

-- 行號
vim.opt.number         = true
vim.opt.relativenumber = true

-- 外觀
vim.opt.cursorline  = true
vim.opt.signcolumn  = "yes"
vim.opt.colorcolumn = "80"
vim.opt.background  = "dark"
vim.opt.termguicolors = true
vim.opt.showmode    = false
vim.opt.cmdheight   = 2
vim.opt.showtabline = 2

-- 縮排
vim.opt.tabstop     = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth  = 2
vim.opt.shiftround  = true
vim.opt.expandtab   = true
vim.opt.autoindent  = true
vim.opt.smartindent = true

-- 搜索
vim.opt.ignorecase = true
vim.opt.smartcase  = true
vim.opt.hlsearch   = false
vim.opt.incsearch  = true

-- 不可見字符
vim.opt.list      = true
vim.opt.listchars = { space = "·" }

-- 補全
vim.opt.wildmenu    = true
vim.opt.pumheight   = 10
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.opt.shortmess:append("c")

-- 視窗 / buffer
vim.opt.wrap       = false
vim.opt.whichwrap  = "b,s,<,>,[,],h,l"
vim.opt.hidden     = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.autoread   = true

-- 效能
vim.opt.updatetime = 300
vim.opt.timeoutlen = 200

-- 備份 / swap
vim.opt.backup      = false
vim.opt.writebackup = false
vim.opt.swapfile    = false

-- 剪貼簿
vim.opt.clipboard = "unnamedplus"

-- 滑鼠
vim.opt.mouse = "a"
