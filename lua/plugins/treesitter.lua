return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate", -- 保留,讓你照樣可以用 :TSInstall, :TSUpdate
  lazy = false,        -- 官方也強調不要 lazy-load
  config = function()
    -- ① 指定 parser / queries 安裝位置(預設也是這個,明寫方便你之後 core-ts 共用)
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- ② 用官方新 API 安裝(或補齊)需要的 parser(非同步)
    -- 已移除 jsx(它只是附屬在 javascript/tsx 底下的 query,不是獨立 parser)
    -- 已移除 org:orgmode.nvim 自己內建了編譯好的 org.so(在它自己的
    -- repo 底下 parser/org.so),不需要、也不應該再透過這裡另外裝一份,
    -- 不然會撞成兩份 parser 同時存在,lua_ls/nvim-treesitter 都會警告衝突
    require("nvim-treesitter").install({
      -- 語言
      "go", "gomod", "lua", "rust", "c", "cpp",
      "javascript", "typescript", "tsx", "jsdoc",
      "html", "css", "json", "json5", "yaml", "toml", "csv",
      "markdown", "markdown_inline",
      -- git / ssh 工作流程
      "gitcommit", "git_rebase", "git_config", "gitignore", "ssh_config", "diff",
      -- 建置系統
      "make", "cmake",
      -- 容器(Containerfile 在你的環境裡也被判斷成 dockerfile filetype,不用另外裝 containerfile)
      "dockerfile",
      -- 工具型(query/regex/luadoc 是被其他語言注入使用,不需要自己的 filetype 高亮)
      "vim", "vimdoc", "query", "regex", "luadoc",
    })

    -- 如果你想在 bootstrap 階段阻塞直到裝完,可以改成:
    -- require("nvim-treesitter")
    --   .install({ "go", "lua", "rust", "c", "vim", "vimdoc", "query" })
    --   :wait(300000)  -- 最多等 5 分鐘

    -- ③ 讓 filetype 名稱跟 parser 語言名稱對不上的那幾個,明確關聯起來,
    -- 否則 vim.treesitter.start(bufnr) 不帶語言參數時會找不到對應 parser
    vim.treesitter.language.register("git_rebase", "gitrebase")
    vim.treesitter.language.register("git_config", "gitconfig")
    vim.treesitter.language.register("ssh_config", "sshconfig")

    -- ④ 高亮由內建 Tree-sitter 負責
    local group = vim.api.nvim_create_augroup("BuiltinTreesitterHighlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = {
        -- 語言(補上原本漏掉的 rust)
        "go", "lua", "rust", "c", "cpp",
        "javascript", "typescript", "typescriptreact", "javascriptreact",
        "html", "css", "json", "json5", "yaml", "toml", "csv",
        "markdown", "org",
        -- git / ssh(pattern 用的是實際 filetype 值,不是 parser 名稱)
        "gitcommit", "gitrebase", "gitconfig", "gitignore", "sshconfig", "diff",
        -- 建置系統
        "make", "cmake",
        -- 容器
        "dockerfile",
        -- 工具型
        "vim", "help", "query",
      },
      callback = function(args)
        vim.treesitter.start(args.buf)
      end,
    })

    -- ⑤ 如果想順便啟用內建 TS 折疊(可選)
    -- vim.api.nvim_create_autocmd("FileType", {
    --   group = group,
    --   pattern = { "go", "lua", "rust", "c", "cpp" },
    --   callback = function()
    --     vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    --     vim.wo.foldmethod = "expr"
    --   end,
    -- })
  end,
}
