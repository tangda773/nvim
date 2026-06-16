-- lua/plugins/mini.lua
return {
  -- ── Spec 1：優先載入，只初始化 icons（其他插件的依賴）──────────────
  {
    "echasnovski/mini.nvim",
    name     = "mini-icons",
    lazy     = false,
    priority = 100, -- 比一般插件早，但不用像 colorscheme 那麼高
    config   = function()
      require("mini.icons").setup({})
    end,
  },

  -- ── Spec 2：Starter（啟動畫面，需在 VimEnter 前就緒）──────────────
  {
    "echasnovski/mini.nvim",
    name   = "mini-starter",
    event  = "VimEnter",
    config = function()
      require("plugins.mini.starter")
    end,
  },

  -- ── Spec 3：外觀 / UI（等 Vim 啟動完再掛上去）───────────────────
  {
    "echasnovski/mini.nvim",
    name   = "mini-ui",
    event  = "VeryLazy",
    config = function()
      -- Appearance
      vim.cmd([[colorscheme randomhue]])
      require("plugins.mini.animate")
      require("plugins.mini.colors")
      require("plugins.mini.cursorword")
      require("plugins.mini.hipatterns")
      require("plugins.mini.indentscope")
      require("plugins.mini.map")
      require("plugins.mini.statusline")
      require("plugins.mini.tabline")
      require("plugins.mini.trailspace")
      -- 通知（noice 的 fallback）
      -- require("plugins.mini.notify")
    end,
  },

  -- ── Spec 4：編輯增強（進入 Insert 或打開 Buffer 才需要）──────────
  {
    "echasnovski/mini.nvim",
    name   = "mini-editing",
    event  = { "InsertEnter", "BufReadPost" },
    config = function()
      require("plugins.mini.ai") -- 文字物件（BufReadPost 觸發即可）
      require("plugins.mini.align")
      require("plugins.mini.comment")
      require("plugins.mini.keymap")
      require("plugins.mini.operators")
      require("plugins.mini.pairs") -- InsertEnter 觸發
      require("plugins.mini.splitjoin")
      require("plugins.mini.surround")
    end,
  },

  -- ── Spec 5：工作流工具（完全延遲）───────────────────────────────
  {
    "echasnovski/mini.nvim",
    name   = "mini-workflow",
    event  = "VeryLazy",
    config = function()
      require("plugins.mini.basics") -- 基礎選項（和 basic.lua 擇一）
      require("plugins.mini.bracketed")
      require("plugins.mini.bufremove")
      require("plugins.mini.clue") -- which-key 替代
      require("plugins.mini.extra")
      require("plugins.mini.files")
      require("plugins.mini.git")
      require("plugins.mini.jump")
      require("plugins.mini.jump2d")
      require("plugins.mini.misc")
      require("plugins.mini.sessions")
      require("plugins.mini.visits")
    end,
  },

  -- ── Spec 6：treesitter 整合（需等 treesitter 載入後）────────────
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event        = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim",
    },
    config       = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter
      require("mini.ai").setup({
        custom_textobjects = {
          c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
          F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          o = spec_treesitter({
            a = { "@loop.outer", "@conditional.outer" },
            i = { "@loop.inner", "@conditional.inner" },
          }),
        },
      })
    end,
  }
}
