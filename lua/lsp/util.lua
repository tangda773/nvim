local M = {}

local _capabilities = nil
local function get_capabilities()
  if not _capabilities then
    local c = vim.lsp.protocol.make_client_capabilities()
    _capabilities = require("cmp_nvim_lsp").default_capabilities(c)
    _capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
  end
  return _capabilities
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local function nmap(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("gf",         vim.lsp.buf.format,         "LSP: Format")
    nmap("gq",         vim.diagnostic.setloclist,  "LSP: Diagnostics List")

    -- 交給 LspUI.nvim
    nmap("gd",         vim.lsp.buf.definition,     "LSP: Goto Definition")
    nmap("gr",         vim.lsp.buf.references,     "LSP: Goto References")
    nmap("<leader>rn", vim.lsp.buf.rename,         "LSP: Rename")
    nmap("<leader>ca", vim.lsp.buf.code_action,    "LSP: Code Action")
  end,
})

M.setup = function()
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN]  = "",
        [vim.diagnostic.severity.HINT]  = "",
        [vim.diagnostic.severity.INFO]  = "",
      },
    },
  })

  vim.lsp.config("*", {
    capabilities = get_capabilities(),
  })

  -- 啟動所有 server
  vim.lsp.enable({
    "clangd",
    "lua_ls",
    -- 日後新增只要加這裡一行
    -- "pyright",
    -- "bashls",
    -- "rust_analyzer",  -- 注意：rust 用 rustaceanvim 就不要加這行
  })
end

return M
