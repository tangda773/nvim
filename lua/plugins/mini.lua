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
      require("plugins.mini.misc")

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
          require("plugins.mini.diff")
          require("plugins.mini.jump")
          require("plugins.mini.move")
          -- require("plugins.mini.jump2d")
          require("plugins.mini.sessions")
          require("plugins.mini.visits")
        end,
      })
    end,
  },
}
