local opts = {
  on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    require("keybindings").mapLSP(buf_set_keymap)
  end,
  settings = {
    texlab = {
      bibtexFormatter = "texlab",
      build = {
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        onSave = false,
      },
      chktex = {
        onEdit = true,
        onOpenAndSave = false,
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        executable = "sioyek",
        args = {
          "--reuse-window",
          "--execute-command",
          "toggle_synctex",
          "--inverse-search",
          'texlab inverse-search -i "%%1" -l %%2',
          "--forward-search-file",
          "%f",
          "--forward-search-line",
          "%l",
          "%p",
        },
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = false,
      },
    },
  },
}

-- 使用 cmp_nvim_lsp 代替内置 omnifunc，獲得更强的補全體驗
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
-- opts.capabilities = capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
opts.capabilities = capabilities

return {
  on_setup = function(server)
    server.setup(opts)
  end,
}
