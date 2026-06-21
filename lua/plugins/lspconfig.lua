return {
  {
    "mason-org/mason.nvim",
    opts = {},
    lazy = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    opts         = {
      ensure_installed = { "clangd", "lua_ls" },
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
