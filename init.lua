vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.loader.enable()

require("basic")
require("config.lazy")
require("keybinding")


-- ui2（0.12 新功能，cmdline / messages 重寫）
-- vim.o.messagesopt = "hit-enter,history:500"

-- 所有 float 統一加邊框
vim.o.winborder = "rounded"

-- 遵守 gofmt/gopls 的 Tab 風格，但在畫面上看起來像 2-space

local go_group = vim.api.nvim_create_augroup("GoIndent", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = false -- 正常用 Tab
    vim.opt_local.list = false      -- 不顯示 ^I
  end,
})
