return {
  -- Mason 主插件，僅在需要時載入
  {
    "mason-org/mason.nvim",
    opts = {},
    lazy = true,
  },
  -- mason-lspconfig，依賴 mason，僅在需要時載入
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    opts = {
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
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      require("lsp.util").setup()
    end,
  },
}
