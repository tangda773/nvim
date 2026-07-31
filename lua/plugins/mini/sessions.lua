require("mini.sessions").setup({})

vim.keymap.set("n", "<leader>ss", function() MiniSessions.select() end, { desc = "Select Session" })
vim.keymap.set("n", "<leader>sw", function()
  vim.ui.input({ prompt = "Session name: " }, function(name)
    if name and name ~= "" then MiniSessions.write(name) end
  end)
end, { desc = "Write Session" })
