-- plugins/agentic.lua
return {
  "carlos-algms/agentic.nvim",
  opts = {
    provider = "claude-agent-acp", -- 預設 provider
    windows = {
      position = "right",          -- "right" | "left" | "bottom"
      width = "40%",
    },
  },
  keys = {
    -- 開關聊天視窗
    {
      "<C-\\>",
      function() require("agentic").toggle() end,
      mode = { "n", "v", "i" },
      desc = "Toggle Agentic"
    },
    -- 把目前檔案或選取文字加入 context
    {
      "<C-'>",
      function() require("agentic").add_selection_or_file_to_context() end,
      mode = { "n", "v" },
      desc = "Add to Agentic context"
    },
    -- 新開一個 session
    {
      "<C-,>",
      function() require("agentic").new_session() end,
      mode = { "n", "v", "i" },
      desc = "New Agentic session"
    },
    -- 把目前行的 LSP 診斷錯誤加入 context
    {
      "<leader>ad",
      function() require("agentic").add_current_line_diagnostics() end,
      mode = "n",
      desc = "Add diagnostics to Agentic"
    },
    -- 恢復之前的 session（終端機繼續）
    {
      "<A-i>r",
      function() require("agentic").restore_session() end,
      mode = { "n", "v", "i" },
      desc = "Restore Agentic session"
    },
  },
}
