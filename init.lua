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
