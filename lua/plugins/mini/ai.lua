-- lua/plugins/mini/ai.lua（更新後）
local spec_treesitter = require("mini.ai").gen_spec.treesitter

require("mini.ai").setup({
  custom_textobjects = {
    -- 函數
    F = spec_treesitter({
      a = "@function.outer",
      i = "@function.inner",
    }),
    -- 類別
    c = spec_treesitter({
      a = "@class.outer",
      i = "@class.inner",
    }),
    -- 迴圈 + 條件
    o = spec_treesitter({
      a = { "@loop.outer",        "@conditional.outer" },
      i = { "@loop.inner",        "@conditional.inner" },
    }),
    -- 區塊（block）
    B = spec_treesitter({
      a = "@block.outer",
      i = "@block.inner",
    }),
  },
  -- n_lines：往上往下搜尋幾行找 textobject
  n_lines = 50,
})
