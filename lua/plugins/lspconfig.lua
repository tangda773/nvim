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
    opts = {
      ensure_installed = { "clangd", "lua_ls" },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      -- LSP 設定在這裡觸發，不需要獨立的 lsp-setup 外掛
      require("lsp.util").setup()
    end,
  },
}
