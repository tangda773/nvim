# nvim

個人 Neovim 設定，鎖定 **Neovim ≥ 0.11 / 建議 0.12+**。插件管理使用 [`zpack.nvim`](https://github.com/zuqini/zpack.nvim)（薄封裝於內建 `vim.pack`）。

**核心方向**：原生 API 優先、mini.nvim 生態系取代大型 all-in-one 插件、LSP + Treesitter + AI 協作三軌並行。

支援語言：Go / Rust / C·C++ / Lua / Bash / TypeScript·JavaScript / HTML / CSS / JSON / YAML。

---

## 插件清單

| 插件                                               | 主要功能                                                   |
| -------------------------------------------------- | ---------------------------------------------------------- |
| `zpack.nvim`                                       | 插件管理器（基於 `vim.pack`）                              |
| `mini.nvim`                                        | 30 個子模組，見下節                                        |
| `agentic.nvim`                                     | ACP AI 對話面板 + diff 預覽（接 `claude-agent-acp`）       |
| `blink.cmp`                                        | 補全引擎（LSP / snippet / buffer / path / cmdline）        |
| `LuaSnip` + `friendly-snippets`                    | Snippet 引擎                                               |
| `codecompanion.nvim`                               | AI 協作（CLI 模式，接 `claude` 指令）                      |
| `conform.nvim`                                     | 存檔自動格式化（`stylua`/`rustfmt`/`prettier`/`gofumpt`…） |
| `crates.nvim`                                      | Cargo.toml 版號補全與操作                                  |
| `nvim-dap` + `nvim-dap-ui` + `mason-nvim-dap.nvim` | DAP 除錯                                                   |
| `faster.nvim`                                      | 大檔案效能降級                                             |
| `fzf-lua`                                          | 模糊搜尋（檔案、grep、buffer）                             |
| `fzf-org.nvim`                                     | Org 檔案 / headline picker                                 |
| `lazydev.nvim`                                     | Neovim Lua API 型別提示                                    |
| `mason.nvim` + `mason-lspconfig.nvim`              | LSP / DAP / formatter 安裝管理                             |
| `nvim-lspconfig`                                   | LSP 主設定（見 `lua/lsp/`）                                |
| `neogen`                                           | 依 Treesitter 產生 docstring                               |
| `neogit` + `diffview.nvim`                         | 完整 Git 操作 UI                                           |
| `neotest` + adapters                               | 測試執行 UI（Python / Go / C++ / 通用）                    |
| `rustaceanvim`                                     | Rust / rust-analyzer 深度整合                              |
| `nvim-bqf`                                         | Quickfix 視窗增強                                          |
| `obsidian.nvim`                                    | Obsidian vault 整合                                        |
| `orgmode`                                          | Org-mode 任務 / agenda                                     |
| `overseer.nvim`                                    | 建置與任務執行管理                                         |
| `profile.nvim`                                     | 啟動 / 執行期效能剖析                                      |
| `remote-sshfs.nvim`                                | SSHFS 遠端掛載                                             |
| `render-markdown.nvim`                             | Markdown 行內渲染                                          |
| `smart-splits.nvim`                                | 跨視窗導航 / 縮放 / 交換                                   |
| `snacks.nvim`                                      | `vim.ui.input`、通知系統、scratch buffer、游標詞高亮       |
| `statuscol.nvim`                                   | 自訂 statuscolumn                                          |
| `toggleterm.nvim`                                  | 多佈局終端機管理                                           |
| `nvim-treesitter`                                  | 語法解析 / 高亮                                            |
| `nvim-ufo`                                         | 進階折疊（LSP / Treesitter / indent）                      |

---

## mini.nvim 子模組

| 子模組             | 載入時機    | 功能                                                              |
| ------------------ | ----------- | ----------------------------------------------------------------- |
| `mini.icons`       | 立即        | 檔案圖示提供者                                                    |
| `mini.colors`      | 立即        | 配色工具（`randomhue` colorscheme）                               |
| `mini.starter`     | 立即        | 開機首頁                                                          |
| `mini.misc`        | 立即        | `setup_auto_root` + `setup_restore_cursor`                        |
| `mini.ai`          | BufReadPost | 進階文字物件（`F`=函式 / `c`=類別 / `o`=迴圈條件 / `B`=block）    |
| `mini.align`       | BufReadPost | 對齊                                                              |
| `mini.comment`     | BufReadPost | 註解切換                                                          |
| `mini.keymap`      | BufReadPost | 多步驟 keymap（目前設定已被註解）                                 |
| `mini.operators`   | BufReadPost | evaluate / exchange / multiply / replace / sort                   |
| `mini.pairs`       | BufReadPost | 括號自動配對                                                      |
| `mini.splitjoin`   | BufReadPost | 單行 ↔ 多行切換                                                   |
| `mini.surround`    | BufReadPost | 環繞符號 add / delete / replace                                   |
| `mini.animate`     | VeryLazy    | 游標 / 捲動 / 視窗動畫                                            |
| `mini.cursorword`  | VeryLazy    | 高亮游標所在單字的其他出現位置                                    |
| `mini.hipatterns`  | VeryLazy    | 高亮 FIXME/HACK/TODO/NOTE 與 `#rrggbb`                            |
| `mini.indentscope` | VeryLazy    | 縮排引導線（`[i`/`]i` 跳轉至 scope 頂 / 底）                      |
| `mini.map`         | VeryLazy    | 程式碼縮圖（`:lua MiniMap.toggle()` 手動開關）                    |
| `mini.statusline`  | VeryLazy    | 狀態列（含 LSP progress）                                         |
| `mini.tabline`     | VeryLazy    | 分頁 / buffer 列                                                  |
| `mini.trailspace`  | VeryLazy    | 標示行尾多餘空白                                                  |
| `mini.basics`      | VeryLazy    | 通用便利選項與 mapping 預設集合                                   |
| `mini.bracketed`   | VeryLazy    | `[x`/`]x` 跳轉（13 種類型，indent 停用讓位給 `mini.indentscope`） |
| `mini.bufremove`   | VeryLazy    | 刪除 / wipeout buffer（不破壞視窗佈局）                           |
| `mini.clue`        | VeryLazy    | 前綴鍵提示（`<leader>`/`g`/`'`/`"`/`<C-w>`/`z` 等）               |
| `mini.extra`       | VeryLazy    | 額外 picker / 文字物件 / 取值函式                                 |
| `mini.files`       | VeryLazy    | 檔案總管（`use_as_default_explorer = true`，取代 netrw）          |
| `mini.git`         | VeryLazy    | 輕量 Git 狀態（statusline + `<leader>gb/gl/gs/gd/gh`）            |
| `mini.jump`        | VeryLazy    | 加強版 `f`/`F`/`t`/`T` + `;` 重複                                 |
| `mini.sessions`    | VeryLazy    | Session 讀寫                                                      |
| `mini.visits`      | VeryLazy    | 常造訪路徑記錄                                                    |

> `lua/plugins/mini/` 下另有 11 個檔案（`base16`、`deps`、`diff`、`doc`、`fuzzy`、`hues`、`jump2d`、`move`、`pick`、`snippets`、`test`）目前未被 `require`，不生效。

---

## Cheat Sheet

**`<leader>` = `\`　`<localleader>` = `<Space>`**

### 檔案 / 搜尋

| 鍵                          | 功能                                           |
| --------------------------- | ---------------------------------------------- |
| `<leader><leader>`          | 全域模糊搜尋（fzf-lua）                        |
| `<leader>sg`                | 搜尋目前 buffer 內容                           |
| `<leader>ff` / `<leader>fg` | 找檔案 / 全文搜尋（自動判斷本機或 SSHFS 遠端） |
| `l` / `h`（mini.files 內）  | 進入 / 返回上層                                |

### 編輯

| 鍵                    | 功能                                            |
| --------------------- | ----------------------------------------------- |
| `gc` / `gcc`          | 註解 operator / 整行切換（mini.comment）        |
| `sa` / `sd` / `sr`    | 新增 / 刪除 / 替換環繞符號（mini.surround）     |
| `ga` / `gS`           | 對齊 / 單行↔多行（mini.align / mini.splitjoin） |
| `daF` / `dif` / `dic` | 刪除函式 / 迴圈條件 / 類別（mini.ai）           |
| `<leader>=`           | 格式化目前 buffer（conform.nvim）               |
| `<C-s>`（任意模式）   | 存檔並回 Normal                                 |

### 導航

| 鍵                    | 功能                                                       |
| --------------------- | ---------------------------------------------------------- |
| `f`/`F`/`t`/`T` + `;` | 加強版行內跳轉（mini.jump）                                |
| `[x` / `]x`           | 依類型跳前/後（mini.bracketed，`b c d f j l o q t u w y`） |
| `[i` / `]i`           | 跳至縮排 scope 頂 / 底（mini.indentscope）                 |
| `<C-h/j/k/l>`         | 跨視窗移動焦點（smart-splits）                             |
| `<leader>wh/wj/wk/wl` | 調整視窗大小                                               |
| `<leader>wH/wJ/wK/wL` | 與鄰近視窗交換 buffer                                      |
| `]]` / `[[`           | 跳到游標詞的下一個 / 上一個位置（snacks）                  |
| `zR` / `zM`           | 展開 / 收合所有折疊（nvim-ufo）                            |

### LSP（有 LSP attach 的 buffer）

| 鍵                          | 功能                                    |
| --------------------------- | --------------------------------------- |
| `<leader>ld` / `<leader>li` | 定義 / 實作（fzf fuzzy UI）             |
| `<leader>lr`                | 參考（fzf fuzzy UI）                    |
| `<leader>lt`                | 型別定義                                |
| `gD`                        | 宣告（go to declaration）               |
| `<leader>ls` / `<leader>lS` | 文件符號 / Workspace 符號               |
| `gh`                        | Hover Docs                              |
| `<C-s>`（Insert）           | Signature Help                          |
| `<leader>ln` / `<leader>la` | 重新命名 / Code Action                  |
| `<leader>lwa/lwr/lwl`       | Workspace 資料夾 新增 / 移除 / 列出     |
| `]d` / `[d` / `]e` / `[e`   | 下一個 / 上一個 診斷 / 錯誤             |
| `<leader>xe` / `<leader>xq` | 顯示診斷 / 送入 Quickfix               |
| `K`                         | 預覽折疊內容（nvim-ufo）                |

### 補全

| 鍵                    | 功能                             |
| --------------------- | -------------------------------- |
| `<Tab>` / `<S-Tab>`   | 選單下移 / 上移，或 snippet 跳點 |
| `<CR>`                | 確認補全                         |
| `<C-Space>` / `<C-e>` | 手動觸發 / 取消                  |

### Git

| 鍵                          | 功能                      |
| --------------------------- | ------------------------- |
| `<leader>gb` / `<leader>gl` | blame / log（mini.git）   |
| `<leader>gs` / `<leader>gd` | status / diff             |
| `<leader>gh`                | 目前行變更歷史            |
| `<leader>gg`                | Neogit 完整 Git UI        |
| `<leader>gp`                | Neogit push               |

### 測試（`<leader>t`）

| 鍵                          | 功能                             |
| --------------------------- | -------------------------------- |
| `<leader>tr` / `<leader>tf` | 跑最近測試 / 整檔測試（neotest） |
| `<leader>td`                | DAP 除錯模式跑測試               |
| `<leader>to` / `<leader>tS` | 切換輸出面板 / 測試總覽樹        |
| `<F5>`                      | Debug continue                   |
| `<F10>` / `<F11>` / `<F12>` | step over / into / out           |
| `<leader>db` / `<leader>dB` | 切換中斷點 / 設定中斷點          |
| `<leader>dL`                | Log point                        |

### Terminal（`<leader>T`）

| 鍵                       | 功能             |
| ------------------------ | ---------------- |
| `<leader>Tt`             | 底部水平終端機   |
| `<leader>Tv`             | 右側垂直終端機   |
| `<leader>Tf`             | 浮動終端機       |
| `<leader>Tn`             | 獨立分頁終端機   |
| `<esc><esc>`（終端機內） | 回到 Normal 模式 |

### AI（`<leader>a`）

| 鍵                          | 功能                         |
| --------------------------- | ---------------------------- |
| `<C-\>`                     | 開關 Agentic 對話面板        |
| `<leader>aa` / `<leader>ad` | 加入選取 / 診斷到 AI context |
| `<leader>an` / `<leader>ar` | 開新 / 恢復 Agentic session  |
| `<leader>ac` / `<leader>ap` | Claude Code CLI / Ask 模式   |

### Org / 筆記

| 鍵                           | 功能                          |
| ---------------------------- | ----------------------------- |
| `<leader>oa` / `<leader>oc`  | Org agenda / capture          |
| `<leader>of` / `<leader>og`  | fzf 開 Org 檔 / 搜尋 headline |
| `<leader>oi`                 | 開 `~/org/inbox.org`          |
| `<localleader>ot`（.org 內） | 切換 TODO 狀態                |

### Buffer / 遠端 / 其他

| 鍵                                         | 功能                                     |
| ------------------------------------------ | ---------------------------------------- |
| `<leader>bf` / `<leader>bF`               | 開檔案總管 / 定位目前檔案（mini.files）   |
| `<leader>bd` / `<leader>bD`                | 刪除 / wipeout buffer                    |
| `<leader>rc` / `<leader>rd` / `<leader>re` | SSHFS 連線 / 斷線 / 編輯設定             |
| `<leader>.` / `<leader>fs` / `<leader>fn`  | scratch buffer / 選擇 scratch / 通知歷史 |
| `<F1>`                                     | 效能剖析開始 / 停止（profile.nvim）      |

---

## 安裝

**前置條件**

- Neovim ≥ 0.11（建議 0.12+）
- `git`、`ripgrep`、`fd`、`fzf`
- C 編譯器（Treesitter parser 編譯用）
- `nodejs`/`npm`（`claude-agent-acp` / `claude` CLI）
- 各語言 formatter（`stylua`/`rustfmt`/`prettier`/`gofumpt`…，`conform.nvim` 用）
- 選用：`sshfs`（`remote-sshfs.nvim`）

**安裝**

```bash
git clone git@github.com:tangda773/nvim.git ~/.config/nvim          # Linux / macOS
git clone git@github.com:tangda773/nvim.git "$HOME/AppData/Local/nvim"  # Windows
```

首次執行 `nvim` 時 `zpack.nvim` 自動安裝所有插件，`mason.nvim` 安裝語言伺服器，完成後重開即可。

**更新**

```bash
git pull
# 更新插件版本：:ZPack update
```
