---@class lsp.util
---@field setup fun(): nil
local M = {}

---@type lsp.ClientCapabilities?
local _capabilities = nil
---@return lsp.ClientCapabilities
local function get_capabilities()
  if not _capabilities then
    _capabilities = require("blink.cmp").get_lsp_capabilities({})
    _capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
  end
  return _capabilities
end

local function setup_keymaps(bufnr)
  local function map(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end
  -- Format / Diagnostics
  -- conform.nvim 替代為 formatter
  -- nmap("<leader>=", vim.lsp.buf.format, "LSP: Format")
  map("n", "<leader>xe", vim.diagnostic.open_float, "[Diagnostics] Line diagnostics")

  -- Navigation（gd/gI/gr 已移至 fzf-lua <leader>ld/<leader>li/<leader>lr，避免 buffer-local 蓋掉全域 fuzzy 版本）
  map("n", "gD", vim.lsp.buf.declaration, "[LSP] Declaration")
  map("n", "<leader>lt", vim.lsp.buf.type_definition, "[LSP] Type definition")

  -- Diagnostic jump
  map("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
  end, "[LSP] Next diagnostic")
  map("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
  end, "[LSP] Prev diagnostic")
  map("n", "]e", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
  end, "[LSP] Next error")
  map("n", "[e", function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
  end, "[LSP] Prev error")

  -- Diagnostics Quickfix/Loclist
  map("n", "<leader>xq", vim.diagnostic.setqflist, "[Diagnostics] Send to quickfix")
  map("n", "<leader>xl", vim.diagnostic.setloclist, "[Diagnostics] Send to loclist")

  -- Docs
  map("n", "gh", vim.lsp.buf.hover, "[LSP] Hover docs")

  -- Refactor（統一到 <leader>l 前綴，清出 <leader>r、<leader>c、<leader>w 給其他用途）
  map("n", "<leader>ln", vim.lsp.buf.rename, "[LSP] Rename")
  map("n", "<leader>la", vim.lsp.buf.code_action, "[LSP] Code action")
  -- Workspace（<leader>lw 子群組）
  map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, "[LSP/Workspace] Add workspace")
  map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "[LSP/Workspace] Remove workspace")
  map("n", "<leader>lwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[LSP/Workspace] List workspaces")
end

---@type table<string, string>
M.servers = {
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
    signs = { severity = { min = vim.diagnostic.severity.WARN } },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- 游標行：virtual_lines 顯示完整訊息
    virtual_lines = {
      current_line = true,
      severity = { min = vim.diagnostic.severity.WARN },
    },
    -- 關掉 virtual_text，避免和 virtual_lines 重複
    virtual_text = false,
    severity_sort = true,
    update_in_insert = false,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(args)
      setup_keymaps(args.buf)
    end,
  })

  vim.lsp.config("*", { capabilities = get_capabilities() })

  -- 1. 預先載入每個 server 自己的設定 (filetypes/settings/cmd...)
  local server_configs = {}
  for name, module in pairs(M.servers) do
    local ok, cfg = pcall(require, module)
    if ok and type(cfg) == "table" then
      server_configs[name] = cfg
    else
      vim.notify("[LSP] 讀取設定失敗: " .. name, vim.log.levels.WARN)
    end
  end

  local function get_filetypes(name, cfg)
    if cfg.filetypes and #cfg.filetypes > 0 then
      return cfg.filetypes
    end
    -- fallback: 讀 nvim-lspconfig 透過 runtimepath lsp/<name>.lua 提供的內建預設
    local ok, default_cfg = pcall(function()
      return vim.lsp.config[name]
    end)
    if ok and default_cfg and default_cfg.filetypes then
      return default_cfg.filetypes
    end
    return {}
  end

  -- 2. lspconfig 名稱 -> mason 套件名稱的對照，用 mason-lspconfig 公開 API 拿，不手動維護
  local ok_mr, mr = pcall(require, "mason-registry")
  local ok_ml, ml = pcall(require, "mason-lspconfig")
  local lspconfig_to_pkg = (ok_ml and ml.get_mappings().lspconfig_to_package) or {}

  local enabled = {}

  local function configure_and_enable(name)
    if enabled[name] then
      return
    end
    enabled[name] = true
    vim.lsp.config(name, server_configs[name])
    vim.lsp.enable(name)
  end

  local attached = {} -- bufnr -> { [name] = true }

  local function attach_to_buf(bufnr, name)
    attached[bufnr] = attached[bufnr] or {}
    if attached[bufnr][name] then
      return
    end
    attached[bufnr][name] = true

    if vim.api.nvim_buf_is_valid(bufnr) then
      -- 讓 vim.lsp.enable(name) 剛剛註冊好的 FileType autocmd
      -- 用它自己完整、能處理 async root_dir 的邏輯去 attach，
      -- 而不是我們自己土砲組 config 丟給 vim.lsp.start()。
      vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr, modeline = false })
    end
  end

  -- 判斷這個 server 的執行檔是不是已經存在於當前環境的 PATH（不管是系統套件、
  -- cargo/go install、還是手動裝的），不透過 mason 也能用
  local function is_system_installed(name)
    local ok, cfg = pcall(function() return vim.lsp.config[name] end)
    if not ok or not cfg or not cfg.cmd then
      return false
    end

    local exe
    if type(cfg.cmd) == "table" then
      exe = cfg.cmd[1]
    elseif type(cfg.cmd) == "function" then
      -- 少數 server 的 cmd 是函式（動態決定執行檔），這裡先不處理，交給 mason 流程
      return false
    end

    return exe ~= nil and vim.fn.executable(exe) == 1
  end

  local installing = {} -- pkg_name -> { {bufnr, name}, ... } 排隊中的呼叫者


  local function ensure_server(bufnr, name)
    -- 環境裡已經有現成的執行檔，直接啟用，完全不碰 mason-registry
    if is_system_installed(name) then
      configure_and_enable(name)
      attach_to_buf(bufnr, name)
      return
    end

    local pkg_name = lspconfig_to_pkg[name]

    if not ok_mr or not pkg_name or not mr.has_package(pkg_name) then
      configure_and_enable(name)
      attach_to_buf(bufnr, name)
      return
    end

    if mr.is_installed(pkg_name) then
      configure_and_enable(name)
      attach_to_buf(bufnr, name)
      return
    end

    -- 已經有一個安裝在跑了，排隊等它結束，不要重複呼叫 install()
    if installing[pkg_name] then
      table.insert(installing[pkg_name], { bufnr = bufnr, name = name })
      return
    end

    installing[pkg_name] = { { bufnr = bufnr, name = name } }
    local pkg = mr.get_package(pkg_name)
    vim.notify("[LSP] 安裝中: " .. pkg_name, vim.log.levels.INFO)

    pkg:install():once("closed", function()
      vim.schedule(function()
        local waiters = installing[pkg_name] or {}
        installing[pkg_name] = nil

        if pkg:is_installed() then
          for _, w in ipairs(waiters) do
            configure_and_enable(w.name)
            if vim.api.nvim_buf_is_valid(w.bufnr) then
              attach_to_buf(w.bufnr, w.name)
            end
          end
        else
          vim.notify("[LSP] 安裝失敗: " .. pkg_name, vim.log.levels.ERROR)
        end
      end)
    end)
  end

  -- 3. filetype -> servers 反查表，從每個 server 的 filetypes 自動建立
  local ft_to_servers = {}
  for name, cfg in pairs(server_configs) do
    for _, ft in ipairs(get_filetypes(name, cfg)) do
      ft_to_servers[ft] = ft_to_servers[ft] or {}
      table.insert(ft_to_servers[ft], name)
    end
  end

  -- 4. 開檔案時才依 filetype 安裝/啟用對應的 server
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspOnDemand", { clear = true }),
    pattern = vim.tbl_keys(ft_to_servers),
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      for _, name in ipairs(ft_to_servers[ft] or {}) do
        ensure_server(args.buf, name)
      end
    end,
  })
end

return M
