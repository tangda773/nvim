return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-treesitter/nvim-treesitter", lazy = true },
  },
  opts = {
    adapters = {
      acp = {
        claude_code = function()
          return require("codecompanion.adapters").extend("claude_code", {})
        end,
      },
    },
    interactions = {
      chat = {
        adapter = { name = "claude_code" },
      },
      cli = {
        agent = "claude_code",
        agents = {
          claude_code = {
            cmd = "claude",
            args = {},
            description = "Claude Code CLI",
            provider = "terminal",
          },
        },
      },
    },
  },
  keys = {
    { "<leader>acc", "<cmd>CodeCompanionChat<cr>",                     desc = "[AI/CC] Chat (ACP)" },
    { "<leader>aca", "<cmd>CodeCompanionActions<cr>",                  desc = "[AI/CC] Action Palette" },
    { "<leader>act", function() require("codecompanion").toggle() end, desc = "[AI/CC] Toggle CLI" },
    { "<leader>acp", "<cmd>CodeCompanionCLI Ask<cr>",                  desc = "[AI/CC] Ask (CLI)" },
  },
}
