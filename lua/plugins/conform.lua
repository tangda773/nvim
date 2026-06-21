-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd   = { "ConformInfo" },
  opts  = {
    -- ── Formatters ──────────────────────────────────────────
    formatters_by_ft = {
      -- Lua
      lua = { "stylua" },

      -- Rust（rustfmt 通常透過 rust-analyzer 處理，但也可以獨立）
      rust = { "rustfmt" },

      -- C / C++
      c   = { "clang_format" },
      cpp = { "clang_format" },

      -- Python
      python = { "ruff_format", "ruff_organize_imports" },

      -- JavaScript / TypeScript
      javascript       = { "prettier" },
      typescript       = { "prettier" },
      javascriptreact  = { "prettier" },
      typescriptreact  = { "prettier" },

      -- Web
      html = { "prettier" },
      css  = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },

      -- Markdown
      markdown = { "prettier" },

      -- Shell
      sh   = { "shfmt" },
      bash = { "shfmt" },

      -- TOML（Rust 專案常用）
      toml = { "taplo" },

      -- 任何有 LSP formatter 的 fallback
      ["*"] = { "trim_whitespace" },
    },

    -- ── 存檔時自動格式化 ────────────────────────────────────
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "prefer",  -- LSP 優先
    },

    -- ── Formatter 客製化 ────────────────────────────────────
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      shfmt = {
        prepend_args = { "-i", "2" },  -- 2 space indent
      },
    },
  },

  config = function(_, opts)
    require("conform").setup(opts)

    vim.keymap.set({ "n", "v" }, "gf", function()
      require("conform").format({
        async      = true,
        lsp_format = "fallback",
      })
    end, { desc = "Format buffer" })
  end,
}
