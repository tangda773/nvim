require("mason-lspconfig").setup({
  -- 自動安裝 Language Servers
  automatic_installation = { exclude = { pyright} },
})

local lspconfig = require("lspconfig")

-- 安裝列表
-- { key: 服務器名， value: 配置文件 }
-- key 必須為下列網址列出的 server name， 不可以隨便寫
-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
local servers = {
  lua_ls = require("lsp.config.lua"), -- lua/lsp/config/lua.lua
  clangd = require("lsp.config.clangd"),
  cmake = require("lsp.config.cmake"),
  texlab = require("lsp.config.texlab"),
  marksman = require("lsp.config.marksman"),
  rust_analyzer = require("lsp.config.rust"),
  taplo = require("lsp.config.taplo"),
  pyright = require("lsp.config.pyright"),
  jsonls = require("lsp.config.jsonls"),
  bashls = require("lsp.config.bashls"),
  hls = require("lsp.config.hls"),
  -- awk_ls = require("lsp.config.awkls"),
  vimls = require("lsp.config.vimls"),
  html = require("lsp.config.htmls"),
  cssls = require("lsp.config.cssls"),
  tsserver = require("lsp.config.tsserver"),
}

for name, config in pairs(servers) do
  if config ~= nil and type(config) == "table" then
    -- 自定義初始化配置文件必須實現on_setup 方法
    config.on_setup(lspconfig[name])
  else
    -- 使用默認參數
    lspconfig[name].setup()
  end
end
