  return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",          -- 用 rewrite 版，非舊 master
    build = ":TSUpdate",
    event = "BufReadPost",    -- 修掉你原本的 lazy = false
    opts = {
      ensure_installed = { "lua", "rust", "c", "vim", "vimdoc", "query" },
    },
    -- 不呼叫 configs.setup()，highlight/indent 交給原生
  }
