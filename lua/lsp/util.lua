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

    -- Format / Diagnostics
    nmap("gf", vim.lsp.buf.format, "LSP: Format")
    nmap("gq", vim.diagnostic.setloclist, "LSP: Diagnostics List")
    nmap("<leader>e", vim.diagnostic.open_float, "LSP: Line Diagnostics")

    -- Navigation
    nmap("gd", vim.lsp.buf.definition, "LSP: Goto Definition")
    nmap("gD", vim.lsp.buf.declaration, "LSP: Goto Declaration")
    nmap("gy", vim.lsp.buf.type_definition, "LSP: Type Definition")
    nmap("gi", vim.lsp.buf.implementation, "LSP: Goto Implementation")
    nmap("gr", vim.lsp.buf.references, "LSP: Goto References")

    -- Diagnostic jump
    nmap("gn", function() vim.diagnostic.jump({ count = 1, float = true }) end, "LSP: Next Diagnostic")
    nmap("gp", function() vim.diagnostic.jump({ count = -1, float = true }) end, "LSP: Prev Diagnostic")
    nmap("]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
      "LSP: Next Error")
    nmap("[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end,
      "LSP: Prev Error")

    -- Docs
    nmap("gh", vim.lsp.buf.hover, "LSP: Hover Docs")
    nmap("<C-k>", vim.lsp.buf.signature_help, "LSP: Signature Help")

    -- Refactor
    nmap("<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
    nmap("<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")

    -- Workspace
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "LSP: Add Workspace")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "LSP: Remove Workspace")
    nmap("<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "LSP: List Workspaces")
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
