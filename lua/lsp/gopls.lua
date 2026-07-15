return {
  settings = {
    gopls = {
      -- conform.nvim
      -- gofumpt = true,            -- 格式化用 gofumpt 而非 gofmt
      completeUnimported = true, -- 自動 import 補全
      usePlaceholders = true,    -- 函式補全時自動填入參數占位符
      staticcheck = true,        -- 額外 static analysis
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
      },
    },
    hints = {
      assignVariableTypes    = true,
      compositeLiteralFields = true,
      compositeLiteralTypes  = true,
      constantValues         = true,
      functionTypeParameters = true,
      parameterNames         = true,
      rangeVariableTypes     = true,
    },
  }
}
