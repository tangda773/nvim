-- zpack 本身就靠 vim.pack 安裝,一行搞定,不需要像 lazy.nvim 那樣手動
-- git clone 到 lazypath 再 vim.opt.rtp:prepend()
local ok, err = pcall(vim.pack.add, { "https://github.com/zuqini/zpack.nvim" })
if not ok then
  vim.notify("zpack.nvim 安裝失敗\n" .. tostring(err), vim.log.levels.ERROR)
  return
end

require("zpack").setup({
  -- 不傳 import 路徑的話,預設就是掃 lua/plugins/*.lua ——跟你現有的
  -- plugins/ 目錄結構完全對得上,不用搬檔案、不用改路徑。
  --
  -- 這裡順便說明為什麼 plugins/mini/*.lua 不會被誤判成 spec:
  -- zpack 的 import 規則是「lua/{path}/*.lua 這一層 + lua/{path}/*/init.lua」,
  -- 也就是只掃 plugins/ 底下「直接」的 .lua 檔案,不會遞迴進 plugins/mini/
  -- 這種子資料夾(除非裡面剛好叫 init.lua)。所以 plugins/mini.lua(頂層,
  -- 回傳 mini.nvim 的 spec)會被匯入,plugins/mini/ai.lua 這些純設定檔
  -- 完全不會被當成 spec 處理——結構不用動。
  defaults = {
    confirm = false, -- 跳過安裝確認彈窗
  },
  performance = {
    vim_loader = true, -- byte-code cache,開機更快
  },
})
