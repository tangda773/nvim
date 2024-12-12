local opts = {
  on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
     end
     require('keybindings').mapLSP(buf_set_keymap)
     require("illuminate").on_attach(client)
  end
}

-- 使用 cmp_nvim_lsp 代替内置 omnifunc，獲得更强的補全體驗
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
opts.capabilities = capabilities

return {
  on_setup = function(server)
  server.setup(opts)
  end
}
