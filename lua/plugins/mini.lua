-- lua/plugins/mini.lua
return {
  {
    "echasnovski/mini.nvim",
    lazy     = false,
    priority = 1000,
    config   = function()
      -- ── 立即執行 ──────────────────────────────────────────
      require("plugins.mini.icons")
      require("plugins.mini.colors")
      vim.cmd([[colorscheme randomhue]])
      require("plugins.mini.starter")


      -- ── BufReadPost / InsertEnter ─────────────────────────
      vim.api.nvim_create_autocmd({ "InsertEnter", "BufReadPost" }, {
        once = true,
        callback = function()
          require("plugins.mini.ai")
          require("plugins.mini.align")
          require("plugins.mini.comment")
          require("plugins.mini.keymap")
          require("plugins.mini.operators")
          require("plugins.mini.pairs")
          require("plugins.mini.splitjoin")
          require("plugins.mini.surround")
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern  = "VeryLazy",
        once     = true,
        callback = function()
          -- ── VeryLazy（UI） ────────────────────────────────────
          require("plugins.mini.animate")
          require("plugins.mini.cursorword")
          require("plugins.mini.hipatterns")
          require("plugins.mini.indentscope")
          require("plugins.mini.map")
          require("plugins.mini.statusline")
          require("plugins.mini.tabline")
          require("plugins.mini.trailspace")
          -- ── VeryLazy（workflow） ──────────────────────────────
          require("plugins.mini.basics")
          require("plugins.mini.bracketed")
          require("plugins.mini.bufremove")
          require("plugins.mini.clue")
          require("plugins.mini.extra")
          require("plugins.mini.files")
          require("plugins.mini.git")
          -- require("plugins.mini.jump")
          -- require("plugins.mini.jump2d")
          require("plugins.mini.misc")
          require("plugins.mini.sessions")
          require("plugins.mini.visits")
        end,
      })
    end,
  },

  -- ── treesitter 整合（獨立 repo，維持不變）────────────────────────
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
  },
}
