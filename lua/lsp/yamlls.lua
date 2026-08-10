---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      validate = true,
      schemaStore = { enable = false, url = "" }, -- 關掉內建 store,改用 SchemaStore.nvim
      schemas = require("schemastore").yaml.schemas(),
      keyOrdering = false,                        -- 避免對 key 順序報 lint 錯誤(常見誤觸雷區)
    },
  },
}
