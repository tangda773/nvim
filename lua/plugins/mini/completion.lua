require("mini.completion").setup({})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker_input",
  callback = function()
    vim.b.minicompletion_disable=true
  end,
  desc = "mini.completion off in snacks_picker",
})
