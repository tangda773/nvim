require("mini.bufremove").setup({})
vim.keymap.set('n', '<leader>bd', MiniBufremove.delete, { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', MiniBufremove.wipeout, { desc = 'Wipeout buffer' })
