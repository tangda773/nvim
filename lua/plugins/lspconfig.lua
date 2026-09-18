return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      automatic_enable = false, -- 交给 lsp.util 自己在 FileType 時手動 enable
    },
  },
  -- LSP 主配置，只有在打開檔案時才載入
  {
    "neovim/nvim-lspconfig",
    name = "lsp-setup",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason-lspconfig.nvim" },
      { "saghen/blink.cmp" },
    },
    config = function()
      require("lsp.util").setup()
    end,
  },
}
