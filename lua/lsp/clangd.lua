-- lsp/clangd.lua
---@type vim.lsp.Config
return {
  cmd = { "clangd", "--limit-results=1000" },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
  },
  -- root_markers / cmd / filetypes 由 nvim-lspconfig 提供，不需要重寫
}
