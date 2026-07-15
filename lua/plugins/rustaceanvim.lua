return {
  'mrcjkb/rustaceanvim',
  version = vim.version.range('^6'), -- Recommended
  init = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
      },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
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
