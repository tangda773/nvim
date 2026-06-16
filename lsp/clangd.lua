-- lsp/clangd.lua
return {
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
  },
  -- root_markers / cmd / filetypes 由 nvim-lspconfig 提供，不需要重寫
}
