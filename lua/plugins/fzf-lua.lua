return {
  {
    "ibhagwan/fzf-lua",
    version = "main",
    -- 不用宣告 nvim-web-devicons 依賴:你已經有 mini.nvim 提供的
    -- mini.icons,fzf-lua 會自動偵測並沿用,不用另外裝圖示套件。
    cmd = "FzfLua",
    keys = {
      -- 搜尋類（ff/fg 由 remote-sshfs 統一管理，自動判斷本機 or 遠端）
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>",                 desc = "Grep Word Under Cursor" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>",                    desc = "Buffers" },
      { "<leader>fo", "<cmd>FzfLua oldfiles<cr>",                   desc = "Recent Files" },
      { "<leader>fh", "<cmd>FzfLua helptags<cr>",                   desc = "Help Tags" },
      { "<leader>fc", "<cmd>FzfLua commands<cr>",                   desc = "Commands" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>",                    desc = "Keymaps" },
      { "<leader>fr", "<cmd>FzfLua resume<cr>",                     desc = "Resume Last Search" },

      -- Git(大寫版本,跟 plugins/mini/git.lua 的 <leader>gs/<leader>gb 錯開;
      -- mini.git 是直接看 git CLI 輸出,這裡是互動式模糊搜尋,兩者互補不是重複)
      { "<leader>gS", "<cmd>FzfLua git_status<cr>",                 desc = "Git Status (fuzzy)" },
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>",                desc = "Git Commits (Repo)" },
      { "<leader>gB", "<cmd>FzfLua git_bcommits<cr>",               desc = "Git Commits (Buffer, fuzzy)" },

      -- LSP（統一到 <leader>l 前綴，避免與 lsp/util buffer-local 及 mini.operators 衝突）
      { "<leader>ld", "<cmd>FzfLua lsp_definitions<cr>",            desc = "[LSP] Definition (fuzzy)" },
      { "<leader>lr", "<cmd>FzfLua lsp_references<cr>",             desc = "[LSP] References (fuzzy)" },
      { "<leader>li", "<cmd>FzfLua lsp_implementations<cr>",        desc = "[LSP] Implementation (fuzzy)" },
      { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>",       desc = "[LSP] Document Symbols" },
      { "<leader>lS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "[LSP] Workspace Symbols" },

      -- Diagnostics
      { "<leader>xd", "<cmd>FzfLua diagnostics_document<cr>",       desc = "Diagnostics (Buffer)" },
      { "<leader>xD", "<cmd>FzfLua diagnostics_workspace<cr>",      desc = "Diagnostics (Workspace)" },
    },
    opts = {
      "default-title", -- fzf-lua 內建 profile,標題顯示在視窗上緣,比預設乾淨
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          layout = "flex", -- 視窗夠寬時左右分割,太窄自動改上下
          flip_columns = 120,
        },
      },
      keymap = {
        -- builtin 是 neovim 端(:tmap)的鍵位,fzf 是原生 fzf binary 的鍵位
        builtin = {
          true, -- 繼承預設,只覆蓋下面列的
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          true,
          ["ctrl-q"] = "select-all+accept", -- 全選丟進 quickfix,搭配 <leader>xq 那類流程很順手
        },
      },
      files = {
        git_icons = true,
      },
      grep = {
        rg_glob = true, -- live_grep 時可以直接打 `-- -g '*.lua'` 這種 glob 過濾
      },
    },
  },
}
