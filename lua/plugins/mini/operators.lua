require("mini.operators").setup({
  replace = {
    prefix = "gz", -- 原本 gr，改為 gz，避免與 fzf-lua <leader>lr（lsp_references）衝突
  },
})
