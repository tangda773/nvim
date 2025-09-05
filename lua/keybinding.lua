vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local bufmap = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = event.buf })
    end
    bufmap("n", "gf", function() vim.lsp.buf.format() end, "Lsp Format")
    bufmap("n", "gq", function() vim.diagnostic.setloclist() end, "Lsp Diagnostics Location List")
  end,
})
