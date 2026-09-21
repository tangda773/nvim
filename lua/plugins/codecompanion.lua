return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "lalitmee/codecompanion-spinners.nvim",
    "ravitemer/codecompanion-history.nvim",
  },
  opts = {
    adapters = {
      acp = {
        claude_code = function()
          return require("codecompanion.adapters").extend("claude_code", {
            commands = {
              default = { "/home/kuangtatang/.local/share/pnpm/bin/claude-agent-acp" },
            },
          })
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
    extensions = {
      spinner = {
        opts = {
          style = "snacks"
        }
      },
      history = {
        enabled = true,
        opts = {
          auto_save = true,
          picker = "fzf-lua",
          summary = {
            create_summary_keymap = "gcs",
            browse_summary_keymap = "gbs",
          },
          -- memory = {
          --   auto_create_memories_on_summmary_generation = true,
          --   vectorcode_exe = "vectorcode",
          --   tool_opts = {
          --     default_num = 10, },
          --   notify = true,
          --   index_on_startup = false
          -- },
        }
      },
    }
  },
  keys = {
    { "<leader>acc", "<cmd>CodeCompanionChat<cr>",                     desc = "[AI/CC] Chat (ACP)" },
    { "<leader>aca", "<cmd>CodeCompanionActions<cr>",                  desc = "[AI/CC] Action palette" },
    { "<leader>act", function() require("codecompanion").toggle() end, desc = "[AI/CC] Toggle CLI" },
    { "<leader>acp", "<cmd>CodeCompanionCLI Ask<cr>",                  desc = "[AI/CC] Ask (CLI)" },
  },
}
