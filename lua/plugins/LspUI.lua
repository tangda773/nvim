return{
  {
  "jinzhongjia/LspUI.nvim",
  event= "LspAttach",
  dependencies = {
       -- Optional
      'MeanderingProgrammer/render-markdown.nvim'
  },
  branch = "main",
  config = function()
    require("LspUI").setup({
	  -- config options go here
	  })
    -- Basic keybinding setup
    vim.keymap.set("n", "gh", "<cmd>LspUI hover<CR>")
    vim.keymap.set("n", "gr", "<cmd>LspUI reference<CR>")
    vim.keymap.set("n", "gd", "<cmd>LspUI definition<CR>")
    vim.keymap.set("n", "gD", "<cmd>LspUI type_definition<CR>")
    vim.keymap.set("n", "gi", "<cmd>LspUI implementation<CR>")
    vim.keymap.set("n", "gn", "<cmd>LspUI diagnostic next<CR>")
    vim.keymap.set("n", "gp", "<cmd>LspUI diagnostic prev<CR>")
    vim.keymap.set("n", "<leader>rn", "<cmd>LspUI rename<CR>")
    vim.keymap.set("n", "<leader>ca", "<cmd>LspUI code_action<CR>")
    vim.keymap.set("n", "<leader>ci", "<cmd>LspUI call_hierarchy incoming_calls<CR>")
    vim.keymap.set("n", "<leader>co", "<cmd>LspUI call_hierarchy outgoing_calls<CR>")
  end
  },
}
