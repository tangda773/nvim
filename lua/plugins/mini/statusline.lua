require("mini.statusline").setup({
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git           = MiniStatusline.section_git({ trunc_width = 75 })
      local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location      = MiniStatusline.section_location({ trunc_width = 75 })

      -- LSP progress（0.12 新 API）
      local lsp_progress = ""
      local ok, status = pcall(vim.ui.progress_status)
      if ok and status and status ~= "" then
        lsp_progress = status
      end

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = "MiniStatuslineDevinfo",  strings = { git, diagnostics } },
        "%<",  -- 截斷點
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",  -- 靠右
        { hl = "MiniStatuslineFilename", strings = { lsp_progress } },  -- ← 加這裡
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl,                  strings = { location } },
      })
    end,
  },
})
