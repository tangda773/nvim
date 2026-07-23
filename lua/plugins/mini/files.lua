require("mini.files").setup({})

vim.keymap.set("n", "<leader>bf", function() MiniFiles.open() end,
  { desc = "[Buf] File Explorer" })
vim.keymap.set("n", "<leader>bF", function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0))
end, { desc = "[Buf] File Explorer (current file)" })
