local M = {}

local _capabilities = nil
local function get_capabilities()
  if not _capabilities then
    _capabilities = require('blink.cmp').get_lsp_capabilities({})
    _capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
  end
  return _capabilities
end

local lsp_keymaps_group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_keymaps_group,
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local function nmap(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- Format / Diagnostics
    -- conform.nvim 替代為 formatter
    -- nmap("<leader>=", vim.lsp.buf.format, "LSP: Format")
    nmap("<leader>xe", vim.diagnostic.open_float, "LSP: Line Diagnostics")

    -- Navigation
    nmap("gd", vim.lsp.buf.definition, "LSP: Goto Definition")
    nmap("gD", vim.lsp.buf.declaration, "LSP: Goto Declaration")
    nmap("gy", vim.lsp.buf.type_definition, "LSP: Type Definition")
    nmap("gi", vim.lsp.buf.implementation, "LSP: Goto Implementation")
    nmap("gr", vim.lsp.buf.references, "LSP: Goto References")

    -- Diagnostic jump
    nmap("]d", function() vim.diagnostic.jump({ count = 1 }) end, "LSP: Next Diagnostic")
    nmap("[d", function() vim.diagnostic.jump({ count = -1 }) end, "LSP: Prev Diagnostic")
    nmap("]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
      "LSP: Next Error")
    nmap("[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end,
      "LSP: Prev Error")

    -- Diagnostics Quickfix/Loclist
    nmap("<leader>xq", vim.diagnostic.setqflist, "LSP: Diagnostics -> Quickfix")
    nmap("<leader>xl", vim.diagnostic.setloclist, "LSP: Diagnostics -> Loclist")

    -- Docs
    nmap("gh", vim.lsp.buf.hover, "LSP: Hover Docs")
    nmap("gs", vim.lsp.buf.signature_help, "LSP: Signature Help")

    -- Refactor
    nmap("<leader>rn", vim.lsp.buf.rename, "LSP: Rename")

    nmap("<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
    -- Workspace
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "LSP: Add Workspace")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "LSP: Remove Workspace")
    nmap("<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP: List Workspaces")

    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
})

local servers = {
  bashls = "lsp.bashls",
  clangd = "lsp.clangd",
  lua_ls = "lsp.lua_ls",
  -- pyright = "lsp.pyright",
  gopls = "lsp.gopls",
  ts_ls = "lsp.ts_ls",
  -- rust_analyzer = "lsp.rust_analyzer",
  eslint = "lsp.eslint",
  html = "lsp.html",
  cssls = "lsp.cssls",
  jsonls = "lsp.jsonls",
  yamlls = "lsp.yamlls",

}

M.setup = function()
  vim.diagnostic.config({
    -- 平時：signs + underline 提示有問題
    signs            = { severity = { min = vim.diagnostic.severity.WARN } },
    underline        = { severity = { min = vim.diagnostic.severity.WARN } },

    -- 游標行：virtual_lines 顯示完整訊息
    virtual_lines    = {
      current_line = true,
      severity     = { min = vim.diagnostic.severity.WARN },
    },
    -- 關掉 virtual_text，避免和 virtual_lines 重複
    virtual_text     = false,
    severity_sort    = true,
    update_in_insert = false,
  })

  vim.lsp.config("*", {
    capabilities = get_capabilities(),
  })

  for name, module in pairs(servers) do
    local ok, cfg = pcall(require, module)
    if ok and type(cfg) == "table" then
      vim.lsp.config(name, cfg)
    end
  end

  -- 啟動所有 server
  vim.lsp.enable(vim.tbl_keys(servers))
end

return M
