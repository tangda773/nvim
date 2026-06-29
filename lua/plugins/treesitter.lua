return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",       -- 用 rewrite 版，非舊 master
  build = ":TSUpdate",
  event = "BufReadPost", -- 修掉你原本的 lazy = false
  opts = function()
    require("nvim-treesitter").install({
      "lua",
      "go",
      "rust",
      "c",
      "vim",
      "vimdoc",
      "query",
    })

    -- 啟用 TS 模組
    return {
      highlight = { enable = true },
      indent    = { enable = true },
    }
  end,
  config = function(_, opts)
    -- main 分支的新 API
    require("nvim-treesitter").setup(opts)
  end,
}
