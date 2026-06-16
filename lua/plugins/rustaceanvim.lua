return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  init = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
      },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          local lsp_util = require("lsp.util")
          lsp_util.on_attach(client, bufnr)


          -- rust 專用快捷鍵
        end,
      },
      -- DAP configuration
      dap = {
      },
    }
  end,
  ft = { "rust" }
}
