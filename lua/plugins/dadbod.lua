return {
  {
    "kristijanhusak/vim-dadbod-ui",
    branch = "master",
    dependencies = {
      { "tpope/vim-dadbod",                     branch = "master" },
      -- 選用:SQL 補全,只在 sql/mysql/plsql 檔案類型才載入
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, branch = "master" },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- init 在插件真正載入「之前」就會執行,DBUI 的全域設定用 init 而不是 config,
      -- 確保這些 vim.g 變數在插件的 plugin/ 腳本跑之前就已經設定好
      vim.g.db_ui_use_nerd_fonts = 1

      -- 連線設定,建議用環境變數或 :DBUIAddConnection 手動加,不要把帳密寫死 commit 進版控
      -- 範例(不要真的這樣寫,只是示範格式):
      -- vim.g.dbs = {
      --   { name = "dev", url = "postgres://user:pass@localhost:5432/mydb" },
      -- }

      -- 查詢結果的儲存位置,預設是 ~/.local/share/db_ui,想改路徑再打開這行
      -- vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
    end,
  },
}
