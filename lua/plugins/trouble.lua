return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "[Trouble] Diagnostics (Workspace)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "[Trouble] Diagnostics (Buffer)" },
    { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "[Trouble] Symbols" },
    { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "[Trouble] LSP Defs/Refs" },
    { "<leader>ci", "<cmd>Trouble lsp_incoming_calls toggle focus=false<cr>",     desc = "[Trouble] Incoming Calls" },
    { "<leader>co", "<cmd>Trouble lsp_outgoing_calls toggle focus=false<cr>",     desc = "[Trouble] Outgoing Calls" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "[Trouble] Location List" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "[Trouble] Quickfix List" },
  },
}
