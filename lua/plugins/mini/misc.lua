require("mini.misc").setup({})
-- 開啟自動 root 偵測（對多專案開發很有用）
MiniMisc.setup_auto_root({ '.git', 'Makefile', 'go.mod', 'Cargo.toml', '.obsidian' })
-- 恢復游標位置
MiniMisc.setup_restore_cursor()
