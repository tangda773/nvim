require("mini.bufremove").setup({})
vim.keymap.set('n', '<leader>bd', MiniBufremove.delete, { desc = '[Buffer] Delete' })
vim.keymap.set('n', '<leader>bD', MiniBufremove.wipeout, { desc = '[Buffer] Wipeout' })
