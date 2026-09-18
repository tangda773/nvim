return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    -- ① 指定 parser / queries 安裝位置
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- ② 讓 filetype 名稱跟 parser 語言名稱對不上的那幾個,明確關聯起來
    vim.treesitter.language.register("git_rebase", "gitrebase")
    vim.treesitter.language.register("git_config", "gitconfig")
    vim.treesitter.language.register("ssh_config", "sshconfig")

    -- ③ 抓一次「這個 nvim-treesitter 版本知道怎麼裝」的語言清單,
    --    之後每次 FileType 觸發時拿來對照用,不用每次都重新查
    local available_parsers = require("nvim-treesitter").get_available()

    -- ④ 按需安裝 + 啟動 highlight 的核心邏輯
    local function treesitter_try_attach(buf, language)
      -- 先確認 parser 真的能載入,載入失敗就直接放棄
      if not vim.treesitter.language.add(language) then return end
      -- 再用 pcall 包一層 start(),雙重保護,避免 previewer 快速切換
      -- buffer 時的 async 時機競態把 assert 往外炸
      pcall(vim.treesitter.start, buf, language)
    end

    local group = vim.api.nvim_create_augroup("BuiltinTreesitterHighlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        local buf, filetype = args.buf, args.match
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end -- 這個 filetype 根本沒對應語言,跳過

        local installed_parsers = require("nvim-treesitter").get_installed("parsers")
        if vim.tbl_contains(installed_parsers, language) then
          -- 已經裝好,直接啟動
          treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          -- 有得裝但還沒裝,先裝再啟動(非同步 await,不卡住 UI)
          require("nvim-treesitter").install(language):await(function()
            treesitter_try_attach(buf, language)
          end)
        else
          -- 既沒裝也裝不到(可能是自訂/沒被官方收錄的語言),
          -- 交給 language.add() 內部去判斷有沒有其他來源的 parser
          treesitter_try_attach(buf, language)
        end
      end,
    })

    -- ⑤ 如果想順便啟用內建 TS 折疊(可選)
    -- vim.api.nvim_create_autocmd("FileType", {
    --   group = group,
    --   callback = function(args)
    --     local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    --     if language then
    --       vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    --       vim.wo.foldmethod = "expr"
    --     end
    --   end,
    -- })
  end,
}
