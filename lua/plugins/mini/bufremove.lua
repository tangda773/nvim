require("mini.bufremove").setup({})
vim.keymap.set('n', 'eader>bd', MiniBufremove.delete, { desc = 'Delete buffer' })
vim.keymap.set('n', 'eader>bD', MiniBufremove.wipeout, { desc = 'Wipeout buffer' })
