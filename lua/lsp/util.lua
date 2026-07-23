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
    local function map(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    -- Format / Diagnostics
    -- conform.nvim 替代為 formatter
    -- nmap("<leader>=", vim.lsp.buf.format, "LSP: Format")
    map("n", "<leader>xe", vim.diagnostic.open_float, "LSP: Line Diagnostics")

    -- Navigation（gd/gI/gr 已移至 fzf-lua <leader>ld/<leader>li/<leader>lr，避免 buffer-local 蓋掉全域 fuzzy 版本）
    map("n", "gD",         vim.lsp.buf.declaration,    "[LSP] Declaration")
    map("n", "<leader>lt", vim.lsp.buf.type_definition, "[LSP] Type Definition")

    -- Diagnostic jump
    map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "LSP: Next Diagnostic")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "LSP: Prev Diagnostic")
    map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
      "LSP: Next Error")
    map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end,
      "LSP: Prev Error")

    -- Diagnostics Quickfix/Loclist
    map("n", "<leader>xq", vim.diagnostic.setqflist, "LSP: Diagnostics -> Quickfix")
    map("n", "<leader>xl", vim.diagnostic.setloclist, "LSP: Diagnostics -> Loclist")

    -- Docs
    map("n", "gh", vim.lsp.buf.hover, "LSP: Hover Docs")

    -- Refactor（統一到 <leader>l 前綴，清出 <leader>r、<leader>c、<leader>w 給其他用途）
    map("n", "<leader>ln", vim.lsp.buf.rename,       "[LSP] Rename")
    map("n", "<leader>la", vim.lsp.buf.code_action,  "[LSP] Code Action")
    -- Workspace（<leader>lw 子群組）
    map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder,    "[LSP] Add Workspace")
    map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "[LSP] Remove Workspace")
    map("n", "<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      "[LSP] List Workspaces")

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
