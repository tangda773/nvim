return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate", -- 保留，讓你照樣可以用 :TSInstall, :TSUpdate
  lazy = false,        -- 官方也強調不要 lazy-load[web:66]

  config = function()
    -- ① 指定 parser / queries 安裝位置（預設也是這個，但明寫方便你之後 core-ts 共用）
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- ② 用官方新 API 安裝（或補齊）需要的 parser（非同步）
    require("nvim-treesitter").install({
      "go",
      "lua",
      "rust",
      "c",
      "vim",
      "vimdoc",
      "query",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "yaml",
    })
    -- 如果你想在 bootstrap 階段阻塞直到裝完，可以改成：
    -- require("nvim-treesitter")
    --   .install({ "go", "lua", "rust", "c", "vim", "vimdoc", "query" })
    --   :wait(300000)  -- 最多等 5 分鐘[web:66]

    -- ③ 高亮由內建 Tree-sitter 負責
    local group = vim.api.nvim_create_augroup("BuiltinTreesitterHighlight", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = {
        "go",
        "lua",
        "rust",
        "c",
        "vim",
        "help",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "yaml", },
      callback = function(args)
        vim.treesitter.start(args.buf)
      end,
    })

    -- ④ 如果想順便啟用內建 TS 折疊（可選）
    -- vim.api.nvim_create_autocmd("FileType", {
    --   group = group,
    --   pattern = { "go", "lua", "rust", "c" },
    --   callback = function()
    --     vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    --     vim.wo.foldmethod = "expr"
    --   end,
    -- })
  end,
}
