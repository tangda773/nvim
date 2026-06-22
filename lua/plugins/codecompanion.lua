return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-treesitter/nvim-treesitter", lazy = true },
  },
  opts = {
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      -- log_level = "DEBUG", -- or "TRACE"
    },
    interactions = {
      cli = {
        agent = "claude_code",
        agents = {
          claude_code = {
            cmd = "claude",
            args = {},
            description = "Claude Code CLI",
            provider = "terminal",
          }
        }
      }
    }
  },
  keys = {
    -- -- Chat 模式（need HTTP Provider）
    -- { "<leader>ac", "<cmd>CodeCompanionChat<cr>", desc = "Chat" },
    -- { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "Action Palette" },

    -- CLI 模式
    { "<leader>cl", "<cmd>CodeCompanionCLI<cr>",     desc = "Claude Code CLI" },
    { "<leader>cp", "<cmd>CodeCompanionCLI Ask<cr>", desc = "Claude Code CLI(Ask)" }
  }
}
