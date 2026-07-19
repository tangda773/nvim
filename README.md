# nvim

個人 Neovim 設定，鎖定 **Neovim ≥ 0.11 / 建議 0.12+**（用到 `vim.pack`、`ui2`、`vim.diagnostic.jump`、`vim.lsp.config` 等新版 API）。插件管理已從 `lazy.nvim` 遷移到 [`zpack.nvim`](https://github.com/zuqini/zpack.nvim)（薄封裝於內建 `vim.pack` 之上）。

> 本文件由設定內容直接整理產生。若你新增/刪除/搬動了插件或 keymap，請依照〈維護與擴充〉一節同步更新此檔，避免文件與實際設定脫節。

---

## 目錄

- [1. 專案簡介](#1-專案簡介)
- [2. 功能總覽](#2-功能總覽)
- [3. 插件清單](#3-插件清單)
- [4. mini.nvim 子模組](#4-mininvim-子模組)
- [5. 插件預設 keybinding](#5-插件預設-keybinding)
- [6. 自訂 keybinding](#6-自訂-keybinding)
- [7. 插件與 keybinding 對照表](#7-插件與-keybinding-對照表)
- [8. 已知的按鍵重疊 / 覆蓋](#8-已知的按鍵重疊--覆蓋)
- [9. 日常操作流程](#9-日常操作流程)
- [10. Cheat Sheet](#10-cheat-sheet)
- [11. 安裝與使用說明](#11-安裝與使用說明)
- [12. 維護與擴充](#12-維護與擴充)

---

## 1. 專案簡介

這是一套以 **LSP + Treesitter + mini.nvim 生態系** 為核心、專注 **Go / Rust / C·C++ / Lua / Web (JS·TS·HTML·CSS)** 開發，並整合 **AI 輔助（Claude Code / Agent Client Protocol）**、**Org-mode / Obsidian 筆記** 與 **遠端開發（SSHFS）** 的個人化 Neovim 設定。

**設計目標**

- **原生優先**：盡量吃滿 Neovim 內建能力（`vim.pack`、內建 LSP、內建 Treesitter 高亮、`vim.diagnostic`、`ui2` 訊息系統），第三方插件只補內建沒有的部分。
- **輕量套件優先於巨型整合套件**：用 `mini.nvim` 一堆各自獨立、可單獨開關的小模組，取代單一大型 all-in-one 插件（例如不用 `nvim-tree`/`telescope`，改用 `mini.files` + `fzf-lua`）。
- **Lazy-load 分層載入**：`mini.nvim` 依「立即載入 → InsertEnter/BufReadPost → VeryLazy」三層延遲載入，兼顧啟動速度與功能完整度（見 `lua/plugins/mini.lua`）。
- **單一事實來源**：LSP 各語言伺服器設定拆到 `lua/lsp/*.lua`，keymap 定義貼近各自的插件檔案（`lua/plugins/*.lua`），不再有集中式 `keybinding.lua`。

**適合的使用情境**

- 日常在 Go / Rust / C·C++ / TypeScript-JavaScript / Lua 專案間切換的後端或系統工程師。
- 需要在終端機內完成「寫程式 → 格式化 → 測試 → debug → git → 呼叫 AI agent」整個迴圈，不想離開 Neovim。
- 同時維護 Org-mode 任務系統與 Obsidian 筆記庫的使用者。
- 需要透過 SSHFS 掛載遠端主機直接編輯檔案的使用者。

**核心特色**

- 內建 LSP（`nvim-lspconfig` + `mason.nvim`）搭配 `blink.cmp` 補全、`conform.nvim` 存檔自動格式化、`nvim-dap` + `nvim-dap-ui` 除錯、`neotest` 測試 UI。
- `mini.nvim`（30 個子模組）撐起檔案總管、Git 狀態、文字物件、環繞符號、對齊、跳轉、statusline/tabline、UI 動畫等日常操作。
- AI 協作雙軌並行：`agentic.nvim`（ACP，接 `claude-agent-acp`）與 `codecompanion.nvim`（CLI 模式接 `claude` 指令）。
- `orgmode` + `fzf-org.nvim` 管理 GTD 風格任務／agenda；`obsidian.nvim` + `render-markdown.nvim` 管理 Markdown 筆記庫。
- `remote-sshfs.nvim` 讓遠端主機檔案系統像本機一樣操作。

---

## 2. 功能總覽

| 類別 | 支援方式 |
|---|---|
| 檔案管理 | `mini.files`（設為預設檔案總管，取代 netrw）、`mini.bufremove`（刪除/wipeout buffer）、`mini.visits`（造訪記錄）、`mini.sessions`（session） |
| 搜尋與跳轉 | `fzf-lua`（全域搜尋、grep）、`mini.jump`（加強版 f/F/t/T）、`mini.bracketed`（`[`/`]` 系列跳轉）、`mini.ai`（文字物件）、`snacks.nvim`（游標詞跳轉） |
| LSP | `nvim-lspconfig` + `mason.nvim` + `mason-lspconfig.nvim`，涵蓋 Go / Rust（`rustaceanvim`）/ C·C++ / Lua / Bash / TS·JS / ESLint / HTML / CSS / JSON / YAML |
| 自動補全 | `blink.cmp`（LSP、snippet、buffer、path、cmdline 來源）+ `LuaSnip` + `friendly-snippets` |
| Git 整合 | `mini.git`（輕量 blame/log/status/diff）、`neogit` + `diffview.nvim`（完整 Git 操作介面） |
| Terminal | `toggleterm.nvim`（四種佈局：底部／右側／浮動／獨立分頁） |
| Markdown / 筆記 | `render-markdown.nvim`（行內渲染）、`obsidian.nvim`（Obsidian vault）、`orgmode` + `fzf-org.nvim`（Org-mode 任務/agenda） |
| AI 協作 | `agentic.nvim`（ACP 協定接 Claude Agent）、`codecompanion.nvim`（CLI 模式接 Claude Code） |
| 除錯 / 測試 | `nvim-dap` + `nvim-dap-ui` + `mason-nvim-dap.nvim`、`neotest`（Python/Go/C·C++/Rust/通用 vim-test 轉接） |
| 任務執行 | `overseer.nvim`（跑建置/執行指令並管理輸出） |
| UI 增強 | `mini.statusline` / `mini.tabline` / `mini.animate` / `mini.indentscope` / `mini.map` / `mini.cursorword` / `mini.hipatterns` / `statuscol.nvim` / `nvim-ufo`（折疊）/ `mini.colors`（`randomhue` 配色） |
| 遠端開發 | `remote-sshfs.nvim`（SSH 掛載瀏覽/編輯） |
| 效能 | `faster.nvim`（大檔案降級）、`profile.nvim`（啟動效能剖析）、`vim.loader.enable()` |
| 其他工作流 | `crates.nvim`（Cargo 版本管理）、`neogen`（docstring 產生器）、`nvim-bqf`（quickfix 增強）、`smart-splits.nvim`（跨視窗導航/縮放/交換） |

---

## 3. 插件清單

> 「依賴關係」只列**功能上**必要或明確設定的依賴，不含 Neovim 內建能力。`mini.nvim` 因子模組眾多，獨立列在[第 4 節](#4-mininvim-子模組)。

| 插件 | 主要功能 | 為什麼需要它 | 工作流角色 | 依賴 | 使用場景 |
|---|---|---|---|---|---|
| `zpack.nvim` | 插件管理器（基於 `vim.pack`） | 取代 `lazy.nvim`，貼合 Neovim 原生套件系統，掃描 `lua/plugins/*.lua` 作為 spec | 基礎設施 | 無 | 開機時自動安裝/載入所有插件 |
| `mini.nvim` | 一整套獨立小工具（檔案總管、Git、文字物件…） | 用可拆解的小模組取代多個大型插件，降低整合複雜度 | 全站 UI + 編輯工作流骨幹 | 無 | 幾乎所有日常編輯操作 |
| `agentic.nvim` | ACP（Agent Client Protocol）AI 對話面板 + diff 預覽 | 在編輯器內直接跟 `claude-agent-acp` 對話、送 context、套用 diff | AI 協作 | 需本機安裝 `claude-agent-acp` | 需要 AI 直接讀寫/建議程式碼變更 |
| `blink.cmp` | 補全引擎 | 效能優於 `nvim-cmp`，原生支援 LSP/snippet/buffer/path/cmdline 多來源 | 自動補全核心 | `LuaSnip`、`friendly-snippets`、`blink.compat`、`cmp-nvim-lua`、`cmp-go-deep` | 打字時觸發補全，Tab 循環選單，Snippet 跳點 |
| `LuaSnip` | Snippet 引擎 | 提供片段展開/跳點能力，`blink.cmp` 委派 snippet 邏輯給它 | 補全子系統 | `blink.cmp` | 展開 `friendly-snippets` 內建片段 |
| `codecompanion.nvim` | AI 協作（CLI 模式） | 以終端機方式直接叫用 `claude` CLI，跟 `agentic.nvim` 互補（不同協定/介面） | AI 協作 | 需本機安裝 `claude` CLI | 想用完整 Claude Code CLI 互動時 |
| `conform.nvim` | 格式化框架 | 依副檔名分派外部 formatter（stylua/rustfmt/prettier/gofumpt…），存檔自動跑 | 存檔前處理 | 對應 formatter 執行檔需另行安裝 | 每次 `BufWritePre`，或手動 `<leader>=` |
| `crates.nvim` | Cargo.toml 版號補全/操作 | 編輯 `Cargo.toml` 時提示可用版本、過期提示、Code Action | Rust 開發輔助 | `*.toml` buffer 觸發 | 加/升級 crate 依賴 |
| `nvim-dap` | DAP 除錯核心引擎 | 提供斷點、逐步執行、continue 等除錯原語 | 除錯 | 各語言 debug adapter（另行安裝） | 中斷點除錯 |
| `nvim-dap-ui` | DAP 圖形化介面 | 顯示 scopes/frames/watch/repl 等除錯視窗 | 除錯 UI | `nvim-dap`、`nvim-nio`、`lazydev.nvim` | 除錯時自動開關浮動視窗 |
| `mason-nvim-dap.nvim` | DAP adapter 安裝橋接 | 讓 `mason.nvim` 也能管理 debug adapter | 除錯基礎設施 | `mason.nvim`、`nvim-dap` | 自動安裝除錯所需 adapter |
| `faster.nvim` | 大檔案效能守門 | 偵測超大檔案時關閉高成本功能，避免卡頓 | 效能 | 無 | 開啟大型 log/生成檔案 |
| `fzf-lua` | 模糊搜尋 / picker | 檔案、grep、buffer 等各種模糊搜尋介面 | 搜尋核心 | 系統需有 `fzf`（或用內建 fzf） | 幾乎所有「找檔案/找內容」場景 |
| `fzf-org.nvim` | Org 檔案/標題 picker | 讓 `fzf-lua` 也能搜尋 Org headline / 檔案 | 筆記搜尋 | `fzf-lua`、`orgmode` | 在大量 `.org` 檔中快速跳轉 |
| `lazydev.nvim` | Neovim Lua API 型別提示 | 撰寫 Neovim 設定/外掛時提供正確的 `vim.*` 型別 | Lua 開發輔助 | 隨 `blink.cmp` 提供補全來源 | 編輯 `*.lua` 設定檔 |
| `mason.nvim` | LSP/DAP/formatter 套件安裝器 | 統一管理各種語言伺服器與工具的安裝 | 基礎設施 | 無 | 首次安裝語言伺服器 |
| `mason-lspconfig.nvim` | Mason ↔ lspconfig 橋接 | 讓 `ensure_installed` 的伺服器自動對應到 `nvim-lspconfig` | LSP 基礎設施 | `mason.nvim` | 自動安裝 `clangd`/`lua_ls` |
| `nvim-lspconfig` | LSP 主設定入口 | 定義/啟用各語言伺服器（見 `lua/lsp/util.lua`） | LSP 核心 | `mason-lspconfig.nvim`、`blink.cmp`（capabilities） | 開檔時自動連接對應語言伺服器 |
| `neogen` | Docstring / 註解產生器 | 依 Treesitter 分析函式簽章自動產生註解骨架 | 文件撰寫輔助 | 需 `LuaSnip` 作為 snippet engine | 幫函式/類別補上文件註解 |
| `neogit` | Git 操作 UI（類 Magit） | 比 `mini.git` 更完整的互動式 Git 操作介面 | Git 工作流 | `plenary.nvim`、`diffview.nvim`、`fzf-lua`（picker） | Stage/commit/push/rebase 等複雜 Git 操作 |
| `diffview.nvim` | Diff / 歷史檢視 | 提供 `neogit` 的 diff 顯示能力 | Git 工作流 | 隨 `neogit` 使用 | 檢視 commit diff、合併衝突 |
| `neotest` | 測試執行 UI | 統一介面跑/看各語言測試結果 | 測試 | `nvim-nio`、`plenary.nvim`、`nvim-treesitter`、多個 adapter（見下） | 執行單一測試/整檔測試並看結果樹 |
| `neotest-python` / `neotest-plenary` / `neotest-gtest` / `neotest-vim-test`(+`vim-test`) | 各語言測試轉接器 | 讓 `neotest` 認得 Python/Lua(plenary)/C++(gtest)/其餘語言測試 | 測試 adapter | `neotest` | 依語言自動選對應 adapter |
| `rustaceanvim` | Rust / rust-analyzer 整合 | 專門處理 Rust LSP、DAP、測試轉接，比通用 lspconfig 更完整 | Rust 開發核心 | 無（獨立管理 rust-analyzer） | 打開 `.rs` 檔時自動啟用 |
| `nvim-bqf` | Quickfix 視窗增強 | 加入預覽、fzf 篩選等能力到內建 quickfix | 搜尋/導航輔助 | `fzf`、`nvim-treesitter` | 瀏覽 `:grep`/LSP 產生的 quickfix 列表 |
| `obsidian.nvim` | Obsidian vault 整合 | 在 Neovim 內編輯 Obsidian 筆記庫（daily note、checkbox、附件） | 筆記系統 | `plenary.nvim`；picker 用 `fzf-lua` | 編輯 `~/notes` 底下的 Markdown 筆記 |
| `orgmode` | Org-mode 任務/agenda 系統 | TODO 狀態機、排程、agenda、capture 模板 | 任務管理 | 無（picker 另由 `fzf-org.nvim` 補強） | GTD 風格的任務/日程管理 |
| `overseer.nvim` | 任務執行器 | 執行並管理建置/執行/測試等 shell 任務 | 工作流自動化 | 無 | 跑 `make`/`cargo build` 等長任務並看輸出 |
| `profile.nvim` | 啟動/執行期效能剖析 | 找出啟動慢或卡頓的來源 | 開發者工具 | 無 | 設 `NVIM_PROFILE` 環境變數或按 `<F1>` 錄製 |
| `remote-sshfs.nvim` | SSHFS 遠端掛載瀏覽 | 把遠端主機當本機檔案系統操作 | 遠端開發 | `fzf-lua`、`plenary.nvim`；系統需有 `sshfs` | 直接編輯遠端伺服器上的程式碼 |
| `render-markdown.nvim` | Markdown 行內渲染 | 標題/清單/程式碼區塊等以更接近所見即所得的樣式顯示 | 筆記/文件閱讀體驗 | `nvim-treesitter`、`mini.nvim`（icon） | 編輯/閱讀 `.md` 檔案 |
| `smart-splits.nvim` | 跨視窗導航/縮放/交換 | 統一 tmux 與 Neovim 視窗導航手感（此設定未接 tmux，純 Neovim 內） | 視窗管理 | 無 | 多分割視窗間移動、調整大小、交換內容 |
| `snacks.nvim` | 綜合 QoL 工具集 | 補齊 `vim.ui.input`、通知系統、暫存 buffer、游標詞高亮等內建缺口 | UI 補完 | 與 `obsidian.nvim` 整合圖片路徑解析 | 彈出輸入框、查看通知歷史、暫存筆記 |
| `statuscol.nvim` | 自訂 statuscolumn | 客製化折疊符號、診斷符號、行號排版 | UI | 無 | 一直顯示在畫面左側 |
| `toggleterm.nvim` | 終端機管理器 | 多個具名終端機、多種佈局，快速切換 | Terminal 工作流 | 無 | 跑背景指令、REPL、`lazygit`/`htop` 等工具 |
| `nvim-treesitter`（`main` 分支） | 語法解析/高亮 | 提供精準語法樹，供高亮、折疊、文字物件使用 | 語言基礎設施 | 無 | 幾乎所有語言的高亮與文字物件依據 |
| `nvim-ufo` | 進階折疊 | 以 LSP/Treesitter/indent 為來源提供更聰明的折疊 | 編輯輔助 | `promise-async` | 折疊/展開程式區塊 |

---

## 4. mini.nvim 子模組

`lua/plugins/mini.lua` 依三層時機載入子模組（見 [1. 專案簡介](#1-專案簡介)）。以下**只列實際被 `require` 的模組**；`lua/plugins/mini/` 目錄下還有 11 個檔案存在但目前未被載入，見表後說明。

| 子模組 | 載入時機 | 功能 | 本設定是否有自訂 |
|---|---|---|---|
| `mini.icons` | 立即 | 檔案/圖示提供者（供 statusline、files、tabline 等使用） | 否，用預設 |
| `mini.colors` | 立即 | 配色工具，本設定用它產生並套用 `randomhue` colorscheme | 是（`colorscheme randomhue`） |
| `mini.starter` | 立即 | 開機首頁（dashboard） | 否，用預設 |
| `mini.misc` | 立即 | 雜項工具：`setup_auto_root`（依 `.git`/`Makefile`/`go.mod`/`Cargo.toml`/`.obsidian` 自動抓 root）、`setup_restore_cursor`（恢復游標位置） | 是（自動 root + 恢復游標） |
| `mini.ai` | InsertEnter/BufReadPost | 進階文字物件（`a`/`i` + 目標字元） | 是（額外加 `F`=函式、`c`=類別、`o`=迴圈+條件、`B`=block 等 Treesitter 文字物件） |
| `mini.align` | 同上 | 對齊工具 | 否，用預設 |
| `mini.comment` | 同上 | 註解切換 | 否，用預設 |
| `mini.keymap` | 同上 | 多步驟 keymap 工具（`map_multistep`） | **範例已寫在檔案但被註解**，目前無實際 multistep 行為 |
| `mini.operators` | 同上 | 一組操作子：evaluate/exchange/multiply/replace/sort | 否，用預設（⚠️ 見[第 8 節](#8-已知的按鍵重疊--覆蓋)衝突） |
| `mini.pairs` | 同上 | 括號/引號自動配對 | 否，用預設 |
| `mini.splitjoin` | 同上 | 單行 ↔ 多行結構切換 | 否，用預設 |
| `mini.surround` | 同上 | 環繞符號 add/delete/replace | 否，用預設 |
| `mini.animate` | VeryLazy | 游標移動/捲動/開關視窗動畫 | 否，用預設 |
| `mini.cursorword` | VeryLazy | 自動高亮游標所在單字的其他出現位置 | 否，用預設 |
| `mini.hipatterns` | VeryLazy | 高亮 `FIXME`/`HACK`/`TODO`/`NOTE` 與 `#rrggbb` 色碼 | 是（自訂四種關鍵字 + hex color 高亮器） |
| `mini.indentscope` | VeryLazy | 顯示目前縮排範圍的引導線 | 否，用預設（⚠️ 見第 8 節） |
| `mini.map` | VeryLazy | 程式碼縮圖（minimap） | 否，用預設（**未綁定開關鍵**，需 `:lua MiniMap.toggle()`） |
| `mini.statusline` | VeryLazy | 狀態列 | 是（自訂內容：mode/git/diagnostics/filename/**LSP progress**/fileinfo/location） |
| `mini.tabline` | VeryLazy | 分頁/緩衝列 | 否，用預設 |
| `mini.trailspace` | VeryLazy | 標示行尾多餘空白 | 否，用預設 |
| `mini.basics` | VeryLazy | 一組常見便利選項/mapping/autocmd 預設集合 | 是（關閉 `windows`、`move_with_alt`；`option_toggle_prefix` 設為空字串以停用切換選項的 `\` 前綴鍵） |
| `mini.bracketed` | VeryLazy | `[`/`]` 系列跳轉（buffer/comment/conflict/diagnostic/file/indent/jump/location/oldfile/quickfix/treesitter/undo/window/yank） | 否，用預設（⚠️ 見第 8 節） |
| `mini.bufremove` | VeryLazy | 刪除/wipeout buffer（不破壞視窗佈局） | 是（本模組**沒有內建預設鍵**，`<leader>bd`/`<leader>bD` 為完全自訂） |
| `mini.clue` | VeryLazy | 觸發鍵提示（which-key 風格彈窗） | 是（自訂哪些前綴鍵要顯示提示：`<leader>`、`g`、`'`、`` ` ``、`"`、`<C-r>`、`<C-w>`、`z`、insert 模式 `<C-x>`） |
| `mini.extra` | VeryLazy | 額外 picker/文字物件/取值函式集合 | 否，用預設（目前未見專屬 keymap 呼叫其功能） |
| `mini.files` | VeryLazy | 檔案總管（樹狀瀏覽/操作） | 部分自訂：預設 `options.use_as_default_explorer = true`，因此本設定停用 netrw 後，**打開任何目錄即自動用 `mini.files` 開啟**；未額外綁定手動開關鍵 |
| `mini.git` | VeryLazy | 輕量 Git 狀態整合（statusline 區塊 + summary） | 是（本模組**沒有內建預設鍵**，`<leader>gb/gl/gs/gd/gh` 為完全自訂，且部分是包一層 `:Git` 指令） |
| `mini.jump` | VeryLazy | 加強版 `f`/`F`/`t`/`T`（延遲高亮、`;` 重複） | 否，用預設 |
| `mini.sessions` | VeryLazy | Session 讀寫 | 否，用預設（未綁定專屬 keymap，走 `:lua MiniSessions.*` 或內建 autocmd 行為） |
| `mini.visits` | VeryLazy | 記錄/查詢常造訪的路徑 | 否，用預設 |

### 未載入（目前不生效）的 mini 子模組

以下檔案存在於 `lua/plugins/mini/`，但**未被 `lua/plugins/mini.lua` `require`**，代表目前不會生效（除非之後手動加回 require 呼叫）：

| 檔案 | 說明 |
|---|---|
| `base16.lua` | base16 調色盤產生器，未使用（實際配色走 `mini.colors` 的 `randomhue`） |
| `deps.lua` | `mini.deps`（另一套插件管理器），與本設定實際使用的 `zpack.nvim` 衝突用途，**應視為遺留檔案** |
| `diff.lua` | Git hunk 內嵌 diff 顯示與操作，未啟用 |
| `doc.lua` | Lua 文件產生器，未啟用 |
| `fuzzy.lua` | 模糊比對函式庫，未啟用（picker 交給 `fzf-lua`） |
| `hues.lua` | 另一個配色產生器，未啟用 |
| `jump2d.lua` | 2D 游標跳轉，**在 `mini.lua` 中被明確註解掉**（`-- require("plugins.mini.jump2d")`），代表刻意停用 |
| `move.lua` | 用 `<M-hjkl>` 搬移可視選取/當前行，未啟用 |
| `pick.lua` | `mini.pick`（另一套 picker），未啟用（picker 交給 `fzf-lua`） |
| `snippets.lua` | `mini.snippets`，未啟用（snippet 引擎交給 `LuaSnip`） |
| `test.lua` | `mini.test` 測試框架，未啟用（測試交給 `neotest`） |

---

## 5. 插件預設 keybinding

大多數現代插件（`agentic.nvim`、`blink.cmp`、`codecompanion.nvim`、`conform.nvim`、`nvim-dap`、`fzf-lua`、`neotest`、`remote-sshfs.nvim`、`smart-splits.nvim`、`snacks.nvim`、`toggleterm.nvim`、`nvim-ufo`、LSP 相關）**本身不內建任何按鍵**，全部按鍵都由本設定的 `lua/plugins/*.lua` 明確指定 —— 這些請直接看[第 6 節：自訂 keybinding](#6-自訂-keybinding)。

會「隨插件自帶預設鍵」且本設定**未覆寫**的，主要集中在 `mini.nvim` 子模組：

| 插件/模組 | 預設 keybinding | 功能說明 | 適用模式 | 備註 |
|---|---|---|---|---|
| `mini.ai` | `a` / `i` + 目標字元 | 文字物件（如 `daf`、`ci"`） | Operator-pending / Visual | 本設定額外加了 `F`(函式)/`c`(類別)/`o`(迴圈+條件)/`B`(block) |
| `mini.ai` | `an` / `in` / `al` / `il` | Next / Last 文字物件變體 | Operator-pending / Visual | 官方文件提及此舉會覆蓋 Neovim ≥0.12/0.13 部分內建鍵，屬 `mini.ai` 自身的既定設計 |
| `mini.ai` | `g[` / `g]` | 移動游標到文字物件左/右邊界 | Normal | |
| `mini.comment` | `gc` | 註解 operator（如 `gcip`）／Visual 切換 | Normal, Visual | |
| `mini.comment` | `gcc` | 切換目前行註解 | Normal | |
| `mini.align` | `ga` | 開始對齊 | Normal, Visual | |
| `mini.align` | `gA` | 開始對齊（含即時預覽） | Normal, Visual | |
| `mini.surround` | `sa` | 新增環繞符號 | Normal, Visual | |
| `mini.surround` | `sd` | 刪除環繞符號 | Normal | |
| `mini.surround` | `sr` | 替換環繞符號 | Normal | |
| `mini.surround` | `sf` / `sF` | 尋找環繞符號（向右/向左） | Normal | |
| `mini.surround` | `sh` | 高亮環繞符號 | Normal | |
| `mini.splitjoin` | `gS` | 單行 ↔ 多行切換 | Normal | |
| `mini.operators` | `g=` / `g=g=` / `g=`(Visual) | Evaluate（求值並取代） | Normal, Visual | |
| `mini.operators` | `gx` / `gxgx` / `gx`(Visual) | Exchange（交換兩段文字） | Normal, Visual | |
| `mini.operators` | `gm` / `gmgm` / `gm`(Visual) | Multiply（複製文字） | Normal, Visual | |
| `mini.operators` | `gr` / `grgr` / `gr`(Visual) | Replace（用暫存器內容取代） | Normal, Visual | ⚠️ 與 LSP 的 `gr`（Goto References）衝突，見第 8 節 |
| `mini.operators` | `gs` / `gsgs` / `gs`(Visual) | Sort（排序） | Normal, Visual | ⚠️ 與 LSP 的 `gs`（Signature Help）衝突，見第 8 節 |
| `mini.indentscope` | `ii` / `ai` | 縮排範圍文字物件 | Operator-pending / Visual | |
| `mini.indentscope` | `[i` / `]i` | 跳到縮排範圍頂/底邊界 | Normal | ⚠️ 被 `mini.bracketed` 覆蓋，見第 8 節 |
| `mini.bracketed` | `[x` / `]x`（`x` = `b,c,d,f,i,j,l,o,q,t,u,w,y`） | 依類型跳到上一個/下一個（buffer/comment/conflict/diagnostic/file/indent/jump/location/oldfile/quickfix/treesitter/undo/window/yank） | Normal | 大寫版本（如 `[B`）跳到第一個/最後一個 |
| `mini.jump` | `f` / `F` / `t` / `T` | 加強版行內字元跳轉（延遲高亮） | Normal, Visual, Operator-pending | |
| `mini.jump` | `;` | 重複上一次跳轉 | Normal, Visual, Operator-pending | |
| `mini.basics` | `j` / `k`（Normal, Visual） | 依可視行移動（無 `[count]` 時） | Normal, Visual | |
| `mini.basics` | `go` / `gO` | 在游標後/前插入空行 | Normal | |
| `mini.basics` | `gy` / `gp` | 複製到/貼上系統剪貼簿 | Normal, Visual | |
| `mini.basics` | `gV` | 重新選取上次變更/複製的文字 | Normal | |
| `mini.basics` | `g/` | 只在目前 Visual 選取範圍內搜尋 | Visual | |
| `mini.basics` | `*` / `#` | 用目前 Visual 選取內容向前/向後搜尋 | Visual | |
| `mini.basics` | `<C-s>` | 儲存並回到 Normal 模式 | Normal, Visual, Insert | |
| `mini.basics`（autocommand） | `TermOpen` 自動進入 Insert；`TextYankPost` 短暫高亮複製範圍 | 便利自動指令 | — | 非按鍵，但屬「預設行為」 |
| `mini.files`（總管內） | `l` / `L` | 進入目錄或開啟檔案 / 開啟並保持焦點 | Normal（總管 buffer 內） | |
| `mini.files`（總管內） | `h` / `H` | 返回上層 / 返回上層並保持焦點 | Normal（總管 buffer 內） | |
| `mini.files`（總管內） | `q` | 關閉總管 | Normal（總管 buffer 內） | |
| `mini.files`（總管內） | `g?` | 顯示說明 | Normal（總管 buffer 內） | |

---

## 6. 自訂 keybinding

所有 `<leader>` 系列鍵前綴是 `\`（`vim.g.mapleader = "\\"`，見 `init.lua`），`<localleader>` 也是 `\`（兩者相同，見[第 8 節](#8-已知的按鍵重疊--覆蓋)的說明）。

| mode | key | action | 對應插件/指令 | 使用情境 | 是否覆蓋預設鍵 |
|---|---|---|---|---|---|
| n, v, i | `<C-\>` | 開關 Agentic 對話面板 | `agentic.nvim` | 隨時呼叫/收起 AI 對話 | 否 |
| n, v | `<leader>aa` | 把選取內容或整個檔案加入 AI context | `agentic.nvim` | 讓 AI 看到目前程式碼 | 否 |
| n, v, i | `<leader>an` | 開新的 Agentic session | `agentic.nvim` | 開始新對話 | 否 |
| n | `<leader>ad` | 把目前行的 LSP 診斷加入 AI context | `agentic.nvim` | 請 AI 幫忙解讀/修錯誤 | 否 |
| n, v, i | `<leader>ar` | 恢復先前的 Agentic session | `agentic.nvim` | 接續前一次對話 | 否 |
| n | `<leader>cl` | 開啟 Claude Code CLI | `codecompanion.nvim` | 用完整 CLI 互動 | 否 |
| n | `<leader>cp` | 呼叫 Claude Code CLI（Ask 模式） | `codecompanion.nvim` | 快速提問 | 否 |
| i, s | `<Tab>` | 補全選單下移 / 無選單時 LuaSnip 向前跳點 | `blink.cmp` + `LuaSnip` | 選補全項或跳到下個 snippet 欄位 | 否（Insert 模式原生 `<Tab>` 本無固定含義） |
| i, s | `<S-Tab>` | 補全選單上移 / 無選單時 LuaSnip 向後跳點 | `blink.cmp` + `LuaSnip` | 同上，反向 | 否 |
| i | `<CR>` | 確認補全 / 無補全時嘗試展開 snippet | `blink.cmp` + `LuaSnip` | 接受補全項目 | 否 |
| i | `<C-b>` / `<C-f>` | 捲動補全文件視窗 上/下 | `blink.cmp` | 閱讀較長的補全說明 | 是（`<C-f>` 覆蓋內建整頁下捲，但只在補全選單開啟時生效） |
| i | `<C-Space>` | 手動觸發補全選單 | `blink.cmp` | 補全未自動彈出時 | 否 |
| i | `<C-e>` | 取消補全 | `blink.cmp` | 關掉補全選單 | 否 |
| c | `preset = cmdline` | 命令列補全（`/` `?` 用 buffer 來源，`:` 用 path+cmdline 來源） | `blink.cmp` | 打 `:`/`/` 時補全 | 否 |
| n, v | `<leader>=` | 格式化目前 buffer（async） | `conform.nvim` | 手動觸發格式化（存檔已自動觸發） | 否 |
| n | `<F5>` | Debug: continue | `nvim-dap` | 開始/繼續除錯 | 否 |
| n | `<F10>` / `<F11>` / `<F12>` | step over / step into / step out | `nvim-dap` | 逐步除錯 | 否 |
| n | `<leader>b` | 切換中斷點 | `nvim-dap` | 設定/移除斷點 | 否 |
| n | `<leader>B` | 設定條件中斷點 | `nvim-dap` | 需要條件式斷點時 | 否 |
| n | `<leader>lp` | 設定 log point | `nvim-dap` | 不中斷但輸出訊息 | 否 |
| n | `<leader>dr` | 開啟 DAP REPL | `nvim-dap` | 除錯時互動求值 | 否 |
| n | `<leader>dl` | 重跑上次的 debug 設定 | `nvim-dap` | 重複除錯同一個目標 | 否 |
| n, v | `<leader>dh` / `<leader>dp` | Widgets Hover / Preview | `nvim-dap-ui` | 檢視變數值 | 否 |
| n | `<leader>df` / `<leader>ds` | 置中浮動視窗顯示 Frames / Scopes | `nvim-dap-ui` | 檢視呼叫堆疊/作用域 | 否 |
| n | `<leader><leader>` | `FzfLua global`（全域搜尋） | `fzf-lua` | 最常用的「找東西」入口 | 否 |
| n | `<leader>sg` | `FzfLua grep_curbuf`（僅搜尋目前 buffer） | `fzf-lua` | 在單一檔案內搜尋字串 | 否 |
| n | `<leader>oa` | Org agenda（另見 `orgmode` 版本，兩者重複定義） | `fzf-org.nvim` / `orgmode` | 查看排程 | **是，與 `orgmode.lua` 的同名鍵重複定義**（見第 8 節） |
| n | `<leader>oc` | Org capture（另見 `orgmode` 版本，兩者重複定義） | `fzf-org.nvim` / `orgmode` | 快速記錄任務 | **是，重複定義**（見第 8 節） |
| n | `<leader>of` | 用 fzf 挑選 Org 檔案 | `fzf-org.nvim` | 開啟特定 `.org` 檔 | 否 |
| n | `<leader>og` | 用 fzf 搜尋所有 Org headline | `fzf-org.nvim` | 快速跳到某個任務/標題 | 否 |
| n | `<leader>or` | Org refile | `fzf-org.nvim` | 把項目搬到別的檔案/標題下 | 否 |
| n | `<leader>oi` | 開啟 `~/org/inbox.org` | `orgmode` | 檢視/整理收件匣 | 否 |
| n（buffer-local，`.org`） | `<localleader>ot` / `<localleader>oT` | 循環切換 / 選單選擇 TODO 狀態 | `orgmode` | 標記任務進度 | 否 |
| n（buffer-local，`.org`） | `<localleader>od` / `<localleader>os` | 設定 DEADLINE / SCHEDULED | `orgmode` | 排定任務時間 | 否 |
| n（buffer-local，`.org`） | `<localleader>oi` | 插入時間戳記 | `orgmode` | 記錄時間點 | 否 |
| n（buffer-local，`.org`） | `<localleader>ol` | 插入連結 | `orgmode` | 交叉引用其他項目 | 否 |
| n（buffer-local，`.org`） | `<localleader>oq` | 設定 tags | `orgmode` | 分類任務 | 否 |
| n（buffer-local，`.org`） | `<localleader>on` / `<localleader>oN` | Narrow / Widen 子樹 | `orgmode` | 聚焦單一子樹編輯 | 否 |
| n | `<leader>bd` / `<leader>bD` | 刪除 buffer / wipeout buffer | `mini.bufremove` | 關閉檔案但不破壞視窗佈局 | 否（模組本身無預設鍵） |
| n | `<leader>gb` | `:vert Git blame -- %` | `mini.git` | 查看每行的作者/commit | 否（模組本身無預設鍵） |
| n | `<leader>gl` | `:Git log --oneline` | `mini.git` | 瀏覽 commit 歷史 | 否 |
| n | `<leader>gs` | `:Git status` | `mini.git` | 查看工作區狀態 | 否 |
| n | `<leader>gd` | `:Git diff` | `mini.git` | 查看未提交的變更 | 否 |
| n | `<leader>gh` | 顯示游標所在行的變更歷史 | `mini.git` | 追蹤某行程式碼的演進 | 否 |
| n | `<leader>tr` / `<leader>tf` | 執行最近的測試 / 執行整個檔案的測試 | `neotest` | TDD 迴圈 | 否 |
| n | `<leader>td` | 以 DAP 除錯模式跑測試 | `neotest` | 測試失敗時逐步除錯 | 否 |
| n | `<leader>ts` / `<leader>ta` | 停止測試 / attach 到執行中的測試 | `neotest` | 中止或觀察長時間測試 | 否 |
| n | `<leader>to` / `<leader>tS` | 切換輸出面板 / 切換測試總覽樹 | `neotest` | 檢視測試輸出/整體結構 | 否 |
| n | `<F1>` | 開始/停止效能剖析並匯出 `profile.json` | `profile.nvim` | 排查啟動或操作卡頓 | 否 |
| n | `<leader>rc` / `<leader>rd` | SSHFS 連線 / 斷線 | `remote-sshfs.nvim` | 開始/結束遠端開發 session | 否 |
| n | `<leader>re` | 編輯 SSHFS 連線設定 | `remote-sshfs.nvim` | 新增/修改遠端主機資訊 | 否 |
| n | `<leader>ff` | 找檔案（有 SSHFS 連線時走遠端，否則走 `fzf-lua files`） | `remote-sshfs.nvim` / `fzf-lua` | 開檔案（本機或遠端皆適用） | 否 |
| n | `<leader>fg` | 全文搜尋（有 SSHFS 連線時走遠端，否則走 `fzf-lua live_grep`） | `remote-sshfs.nvim` / `fzf-lua` | 內容搜尋（本機或遠端皆適用） | 否 |
| n | `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | 跨視窗移動游標焦點 | `smart-splits.nvim` | 分割視窗間切換 | 是（覆蓋內建 `<C-w>h/j/k/l`；`mini.basics` 的 `windows` 選項本設定已刻意設為 `false` 以避免衝突） |
| n | `<A-h>` / `<A-j>` / `<A-k>` / `<A-l>` | 調整視窗大小 | `smart-splits.nvim` | 手動調整分割比例 | 否 |
| n | `<leader>sh` / `<leader>sj` / `<leader>sk` / `<leader>sl` | 與左/下/上/右視窗交換 buffer | `smart-splits.nvim` | 重新排列視窗內容 | 否 |
| n | `]]` / `[[` | 跳到游標詞的下一個/上一個出現位置 | `snacks.nvim`（`Snacks.words`） | 快速找同名變數/符號的其他位置 | 否（`[[`/`]]` 內建無固定含義） |
| n | `<leader>.` | 開關 scratch 暫存 buffer | `snacks.nvim` | 隨手記筆記/暫存程式碼片段 | 否 |
| n | `<leader>fs` | 選擇既有 scratch buffer | `snacks.nvim` | 切換多個暫存內容 | 否 |
| n | `<leader>fn` | 顯示通知歷史 | `snacks.nvim` | 回顧錯過的通知 | 否 |
| n, t | `<leader>tt` / `<leader>t1` | 開關底部水平終端機（T1） | `toggleterm.nvim` | 跑長輸出指令（如 `cargo test --watch`） | 否 |
| n, t | `<leader>t2` | 開關右側垂直終端機（T2） | `toggleterm.nvim` | 互動 shell / REPL | 否 |
| n, t | `<leader>t3` | 開關浮動終端機（T3） | `toggleterm.nvim` | 臨時工具（`lazygit`/`htop`） | 否 |
| n, t | `<leader>t4` | 開關獨立分頁終端機（T4） | `toggleterm.nvim` | 需要長時間獨立 session | 否 |
| t（僅終端機 buffer） | `<esc><esc>` | 從終端機模式回到 Normal 模式 | `toggleterm.nvim` | 在終端機裡切回可操作 Neovim 的模式 | 是（覆蓋終端機模式下 `<esc>` 的預設無動作行為） |
| n | `zR` / `zM` | 展開全部折疊 / 收合全部折疊 | `nvim-ufo` | 快速瀏覽或聚焦程式結構 | 否（沿用內建鍵位但改接 `ufo` 實作） |
| n | `K` | 有折疊時預覽折疊內容，否則呼叫 LSP Hover | `nvim-ufo` + LSP | 遊標在折疊行上快速預覽 | 是（覆蓋內建 `K`＝`:help`／關鍵字說明；與下方 `gh` 功能重疊，見第 8 節） |
| n（buffer-local，LSP attach） | `gd` / `gD` / `gy` / `gi` / `gr` | Goto Definition / Declaration / Type Definition / Implementation / References | `nvim-lspconfig`（`lua/lsp/util.lua`） | 程式碼導航 | `gr` 是（見第 8 節，與 `mini.operators` 衝突） |
| n（buffer-local，LSP attach） | `gh` / `gs` | Hover 文件 / Signature Help | `nvim-lspconfig` | 查看型別/函式簽章說明 | `gs` 是（見第 8 節，與 `mini.operators` 衝突） |
| n（buffer-local，LSP attach） | `]d` / `[d` / `]e` / `[e` | 下一個/上一個診斷 / 錯誤 | `nvim-lspconfig` | 逐一檢視問題 | 否 |
| n（buffer-local，LSP attach） | `<leader>xe` | 顯示游標所在行完整診斷內容 | `nvim-lspconfig` | 看清楚錯誤訊息全文 | 否 |
| n（buffer-local，LSP attach） | `<leader>xq` / `<leader>xl` | 診斷送入 Quickfix / Loclist | `nvim-lspconfig` | 批次瀏覽/修正所有問題 | 否 |
| n（buffer-local，LSP attach） | `<leader>rn` | 重新命名符號 | `nvim-lspconfig` | 安全地全專案重新命名 | 否 |
| n（buffer-local，LSP attach） | `<leader>ca` | Code Action | `nvim-lspconfig` | 套用自動修正/重構建議 | 否 |
| n（buffer-local，LSP attach） | `<leader>wa` / `<leader>wr` / `<leader>wl` | 新增/移除/列出 workspace 資料夾 | `nvim-lspconfig` | 多 root 專案管理 | 否 |

---

## 7. 插件與 keybinding 對照表

只列**有明確按鍵**的插件（純幕後/UI 插件如 `nvim-treesitter`、`mason.nvim`、`render-markdown.nvim`、`faster.nvim` 等不列入）。「常用」為主觀評估，依日常編輯/導航/AI/Git 核心程度判斷。

| 插件 | 主要功能 | 預設 keybinding | 自訂 keybinding | 常用 |
|---|---|---|---|---|
| `mini.ai` | 文字物件 | `a`/`i` + 字元、`an`/`in`/`al`/`il`、`g[`/`g]` | 額外文字物件 `F`/`c`/`o`/`B` | ✅✅✅ |
| `mini.comment` | 註解切換 | `gc`、`gcc` | 無 | ✅✅✅ |
| `mini.surround` | 環繞符號 | `sa`/`sd`/`sr`/`sf`/`sF`/`sh` | 無 | ✅✅✅ |
| `mini.align` | 對齊 | `ga`/`gA` | 無 | ✅ |
| `mini.splitjoin` | 單行↔多行 | `gS` | 無 | ✅ |
| `mini.operators` | 求值/交換/複製/取代/排序 | `g=`/`gx`/`gm`/`gr`/`gs` | 無（⚠️ `gr`/`gs` 在 LSP buffer 內被蓋掉） | ✅（`g=` 常用；`gr`/`gs` 實務上少用到） |
| `mini.indentscope` | 縮排引導線/文字物件 | `ii`/`ai`、`[i`/`]i` | 無（⚠️ `[i`/`]i` 被 `mini.bracketed` 蓋掉） | ✅（視覺提示常見；motion 鍵少用） |
| `mini.bracketed` | `[`/`]` 系列跳轉 | `[x`/`]x`（14 種類型） | 無 | ✅✅ |
| `mini.jump` | 加強版 f/F/t/T | `f`/`F`/`t`/`T`、`;` | 無 | ✅✅✅ |
| `mini.basics` | 通用便利鍵 | `j`/`k`、`go`/`gO`、`gy`/`gp`、`gV`、`g/`、`*`/`#`、`<C-s>` | 停用了 `windows`/`move_with_alt`/`\` 選項切換前綴 | ✅✅ |
| `mini.bufremove` | 刪除 buffer | 無 | `<leader>bd`/`<leader>bD` | ✅✅ |
| `mini.git` | 輕量 Git | 無 | `<leader>gb/gl/gs/gd/gh` | ✅✅ |
| `mini.files` | 檔案總管 | `l`/`L`/`h`/`H`/`q`/`g?` | 無獨立開關鍵（依 `use_as_default_explorer` 自動接管開目錄） | ✅✅✅ |
| `agentic.nvim` | AI 對話（ACP） | 無 | `<C-\>`、`<leader>aa/an/ad/ar` | ✅✅ |
| `codecompanion.nvim` | AI（CLI） | 無 | `<leader>cl/cp` | ✅ |
| `blink.cmp` | 補全 | 無 | `<Tab>`/`<S-Tab>`/`<CR>`/`<C-b>`/`<C-f>`/`<C-Space>`/`<C-e>` | ✅✅✅ |
| `conform.nvim` | 格式化 | 無 | `<leader>=`（存檔另有自動格式化） | ✅✅✅ |
| `nvim-dap`（+ ui） | 除錯 | 無 | `<F5>/<F10>/<F11>/<F12>`、`<leader>b/B/lp/dr/dl/dh/dp/df/ds` | ✅（依語言/情境） |
| `fzf-lua` | 搜尋/picker | 無 | `<leader><leader>`、`<leader>sg` | ✅✅✅ |
| `fzf-org.nvim` / `orgmode` | Org 任務系統 | 無 | `<leader>oa/oc/of/og/or/oi` + `<localleader>o*` | ✅（Org 使用者） |
| `neotest` | 測試 | 無 | `<leader>tr/tf/td/ts/ta/to/tS` | ✅✅ |
| `remote-sshfs.nvim` | 遠端掛載 | 無 | `<leader>rc/rd/re`、`<leader>ff/fg`（覆蓋 fallback） | ✅（遠端開發時） |
| `smart-splits.nvim` | 視窗導航 | 無 | `<C-hjkl>`、`<A-hjkl>`、`<leader>sh/sj/sk/sl` | ✅✅✅ |
| `snacks.nvim` | QoL 工具 | 無 | `]]`/`[[`、`<leader>.`、`<leader>fs`、`<leader>fn` | ✅ |
| `toggleterm.nvim` | 終端機 | 無 | `<leader>tt/t1/t2/t3/t4`、`<esc><esc>` | ✅✅✅ |
| `nvim-ufo` | 折疊 | 無 | `zR`/`zM`/`K`（覆寫） | ✅✅ |
| `nvim-lspconfig` | LSP | 無（buffer-local，附加時建立） | `gd/gD/gy/gi/gr/gh/gs`、`]d/[d/]e/[e`、`<leader>xe/xq/xl/rn/ca/wa/wr/wl` | ✅✅✅ |
| `profile.nvim` | 效能剖析 | 無 | `<F1>` | 偶爾 |
| `crates.nvim` | Cargo 版本 | 依官方 LSP Code Action 觸發（未見額外快捷鍵定義） | 未在設定中找到 | Rust 專案時 |

---

## 8. 已知的按鍵重疊 / 覆蓋

整理設定中**目前確實存在**的重複定義與覆蓋關係（依實際 require 順序與 buffer-local/global 優先權判斷），供未來清理參考：

1. **`<leader>oa` / `<leader>oc` 重複定義**：`lua/plugins/fzf-org.lua`（`keys = {...}`，`lazy = false`）與 `lua/plugins/orgmode.lua`（`event = "VeryLazy"` 內用 `vim.keymap.set` 設定）都各自定義了這兩個鍵，功能幾乎等價（皆呼叫 `orgmode` 的 `agenda.prompt` / `capture.prompt` 或對應 `Org` 指令），但屬**冗餘重複**，建議擇一保留。
2. **`gr`（Goto References vs Replace）**：`mini.operators` 的預設鍵 `gr` = Replace with register（全域 mapping）；`lua/lsp/util.lua` 在 `LspAttach` 時為每個附加 LSP 的 buffer 建立 **buffer-local** 的 `gr` = Goto References。Vim 的按鍵優先權是 buffer-local > global，因此**只要目前 buffer 有 LSP 附加，`gr` 一律是 Goto References**；`mini.operators` 的 Replace 只在無 LSP 的 buffer（如純文字、部分 Markdown/Org）才可觸發。
3. **`gs`（Signature Help vs Sort）**：與上一點相同模式。`mini.operators` 全域 `gs` = Sort；LSP buffer-local `gs` = Signature Help，LSP buffer 內一律以後者為準。
4. **`[i` / `]i`（縮排跳轉重疊）**：`mini.indentscope` 與 `mini.bracketed` 都用 `[i`/`]i` 作為「跳到縮排邊界／變化處」的鍵。兩者皆在 `lua/plugins/mini.lua` 的 `VeryLazy` 區塊被 `require`，且 **`bracketed` 排在 `indentscope` 之後**，全域 mapping 後設定者覆蓋前者，因此目前 `[i`/`]i` 實際上是 `mini.bracketed` 的「跳到下一個縮排變化行」，`mini.indentscope` 的 `goto_top`/`goto_bottom` 已被蓋掉（`ii`/`ai` 文字物件不受影響）。
5. **`gh` 與 `K` 功能重疊（非衝突，但是冗餘）**：`lua/lsp/util.lua` 將 `gh` 綁定為 LSP Hover；`lua/plugins/ufo.lua` 又把 `K` 改成「有折疊時預覽折疊，否則呼叫 `vim.lsp.buf.hover()`」。兩個鍵在多數情況下最終效果相同，屬設計上刻意保留雙鍵位，不算 bug，但值得知道。
6. **`mapleader` 與 `maplocalleader` 相同（皆為 `\`）**：`init.lua` 將兩者都設成 `\`。這代表 `lua/plugins/orgmode.lua` 中所有 `.org` buffer-local 的 `<localleader>o*`（`ot/oT/od/os/oi/ol/oq/on/oN`）在按鍵序列上與 `<leader>o*` 完全相同，只是**作用域不同**（buffer-local 只在 `.org` 檔生效，且會覆蓋同名的全域 `<leader>o*`，例如若未來新增全域 `<leader>ot`，在 `.org` 檔案內會被 Org 的版本蓋掉）。目前沒有實際衝突，但新增全域 `<leader>o*` 鍵前務必檢查這份清單。
7. **`<C-h/j/k/l>` 覆蓋內建視窗切換**：`smart-splits.nvim` 覆蓋了內建 `<C-w>h/j/k/l`；`mini.basics` 的 `mappings.windows` 已在本設定中明確設為 `false`，避免兩者互搶同一組鍵——這是**刻意的正確設定**，非 bug，記錄於此供未來修改時參考不要誤開。

---

## 9. 日常操作流程

- **開啟檔案**
  `<leader><leader>` 呼叫 `fzf-lua` 全域搜尋（含檔案），或直接 `:e <path>` 開啟目錄會自動由 `mini.files` 接管（`use_as_default_explorer = true`）。在 `mini.files` 視窗內用 `l`/`L` 進入、`h`/`H` 返回上層、`q` 關閉。

- **搜尋檔案內容**
  `<leader>sg` 在目前 buffer 內用 `fzf-lua` 搜尋；跨檔搜尋用 `<leader><leader>` 選擇 grep 相關 provider。遠端主機已連線 SSHFS 時，改用 `<leader>ff`（找檔案）/`<leader>fg`（全文搜尋），會自動判斷走本機或遠端。

- **切換 buffer / window / tab**
  視窗間移動用 `<C-h/j/k/l>`（`smart-splits.nvim`），縮放用 `<A-h/j/k/l>`，與鄰近視窗交換內容用 `<leader>sh/sj/sk/sl`。關閉 buffer 用 `<leader>bd`（保留視窗佈局）。Tabline/Statusline 由 `mini.tabline`/`mini.statusline` 顯示目前狀態。

- **使用 LSP**
  開啟受支援語言的檔案（Go/Rust/C·C++/Lua/Bash/JS·TS/HTML/CSS/JSON/YAML）即自動連接對應伺服器（`lua/lsp/util.lua` 的 `LspAttach`）。常用鍵：`gd` 定義、`gr` 參考（無 LSP 時退回 `mini.operators` Replace）、`gh` Hover、`<leader>rn` 重新命名、`<leader>ca` Code Action、`]d`/`[d` 逐一檢視診斷。

- **自動補全**
  輸入時 `blink.cmp` 自動彈出選單；`<Tab>`/`<S-Tab>` 選項目或跳 snippet 欄位，`<CR>` 確認，`<C-Space>` 手動觸發，`<C-e>` 取消。

- **Git 操作**
  快速查詢用 `mini.git` 的 `<leader>gb/gl/gs/gd/gh`；需要完整互動式操作（stage hunk、rebase、conflict 解決）改用 `:Neogit`（`neogit` 未在本設定綁定固定鍵，需自行 `:Neogit` 或另行綁定）。

- **執行終端命令**
  `<leader>tt`（底部）/`<leader>t2`（右側）/`<leader>t3`（浮動）/`<leader>t4`（獨立分頁）依情境開關具名終端機；在終端機內按 `<esc><esc>` 回到 Normal 模式操作視窗，再按一次對應鍵可切回終端機。需要跑建置/長任務並管理輸出時可改用 `:OverseerRun` / `:OverseerToggle`（`overseer.nvim`，未綁定固定鍵）。

- **撰寫 Markdown / 筆記**
  一般 Markdown 由 `render-markdown.nvim` 自動行內渲染；`~/notes` 底下的檔案由 `obsidian.nvim` 管理（daily note、checkbox、附件）。Org-mode 任務用 `<leader>oa`（agenda）、`<leader>oc`（capture）、`<leader>oi`（開 inbox），在 `.org` buffer 內用 `<localleader>ot` 切換 TODO 狀態。

- **AI 輔助編輯**
  快速對話/套用 diff 用 `<C-\>` 開啟 `agentic.nvim` 面板，`<leader>aa` 把目前選取/檔案丟進 context，`<leader>ad` 把診斷丟進 context。需要完整 CLI 體驗則用 `<leader>cl`（`codecompanion.nvim` 開 Claude Code CLI）。

---

## 10. Cheat Sheet

### 檔案 / 搜尋
- `<leader><leader>` — 全域模糊搜尋（`fzf-lua`）
- `<leader>sg` — 搜尋目前 buffer 內容
- `<leader>ff` / `<leader>fg` — 找檔案 / 全文搜尋（自動判斷本機或 SSHFS 遠端）
- `l` / `h`（於 `mini.files` 視窗內） — 進入目錄或開檔 / 返回上層

### 編輯
- `gc` / `gcc` — 註解 operator / 切換整行註解（`mini.comment`）
- `sa` / `sd` / `sr` — 新增 / 刪除 / 替換環繞符號（`mini.surround`）
- `ga` — 對齊（`mini.align`）
- `gS` — 單行 ↔ 多行切換（`mini.splitjoin`）
- `daF` / `dif` / `dic` — 刪除函式 / 迴圈或條件 / 類別文字物件（`mini.ai` 自訂）
- `<leader>=` — 格式化目前 buffer（`conform.nvim`）

### 導航
- `[x` / `]x`（`x=b,c,d,f,i,j,l,o,q,t,u,w,y`） — 依類型跳到前一個/下一個（`mini.bracketed`）
- `f` / `F` / `t` / `T` + `;` — 加強版行內跳轉（`mini.jump`）
- `<C-h/j/k/l>` — 跨視窗移動焦點（`smart-splits.nvim`）
- `]]` / `[[` — 跳到游標詞的下一個/上一個出現位置（`snacks.nvim`）

### LSP
- `gd` / `gr` / `gh` — 定義 / 參考 / Hover
- `<leader>rn` — 重新命名
- `<leader>ca` — Code Action
- `]d` / `[d` — 下一個 / 上一個診斷

### 補全
- `<Tab>` / `<S-Tab>` — 選補全項或跳 snippet 欄位
- `<C-Space>` — 手動觸發補全
- `<CR>` — 確認補全

### Git
- `<leader>gs` / `<leader>gd` / `<leader>gl` / `<leader>gb` — status / diff / log / blame（`mini.git`）

### 測試 / 除錯
- `<leader>tr` / `<leader>tf` — 跑最近測試 / 跑整檔測試（`neotest`）
- `<F5>` — Debug continue（`nvim-dap`）
- `<leader>b` — 切換中斷點

### Terminal
- `<leader>tt` / `<leader>t2` / `<leader>t3` / `<leader>t4` — 底部 / 右側 / 浮動 / 分頁終端機
- `<esc><esc>`（終端機內） — 回到 Normal 模式

### AI
- `<C-\>` — 開關 Agentic 對話面板
- `<leader>aa` — 加入目前檔案/選取內容到 AI context
- `<leader>cl` — 開啟 Claude Code CLI

### Org / 筆記
- `<leader>oa` / `<leader>oc` — Org agenda / capture
- `<localleader>ot`（`.org` 檔內） — 切換 TODO 狀態

---

## 11. 安裝與使用說明

**前置條件**

- Neovim ≥ 0.11（建議 0.12+，設定使用了 `vim.pack`、`ui2`、`vim.diagnostic.jump` 等較新 API）
- `git`（`vim.pack` 透過 git 拉取插件）
- `ripgrep`、`fd`、`fzf`（`fzf-lua` 搜尋依賴）
- C 編譯器（`gcc`/`clang`/MinGW，供 Treesitter parser 與部分插件原生模組編譯）；Windows 另需 Microsoft C++ Build Tools
- `nodejs`/`npm`（若要使用 `agentic.nvim` 的 `claude-agent-acp` 或 `codecompanion.nvim` 的 `claude` CLI）
- 各語言工具鏈（依需求安裝）：`stylua`、`rustfmt`、`clang-format`、`ruff`、`prettier`、`shfmt`、`taplo`、`goimports`/`gofumpt`（`conform.nvim` 格式化用）、`gopls`/`rust-analyzer`（部分由 `mason.nvim` 或 `rustaceanvim` 自動管理）
- 選用：`sshfs`（`remote-sshfs.nvim`）

**安裝方式**

```bash
git clone git@github.com:tangda773/nvim.git "$HOME/AppData/Local/nvim"   # Windows
# 或
git clone git@github.com:tangda773/nvim.git ~/.config/nvim               # Linux / macOS
```

**啟動方式**

直接執行 `nvim`。首次啟動時 `zpack.nvim`（透過 `vim.pack.add`）會自動拉取並安裝所有 `lua/plugins/*.lua` 內宣告的插件，`mason.nvim`/`mason-lspconfig.nvim` 亦會依 `ensure_installed` 清單安裝語言伺服器。安裝期間請保持網路暢通，完成後重開 `nvim` 即可。

**基本使用步驟**

1. 開啟一個專案目錄：`nvim .` → 自動由 `mini.files` 顯示目錄樹。
2. 用 `<leader><leader>` 找到要編輯的檔案。
3. 編輯、存檔（`:w`）會自動觸發 `conform.nvim` 格式化。
4. 需要除錯／測試時用 `<F5>` 或 `<leader>tr`。
5. 需要 AI 協助時用 `<C-\>`（Agentic）或 `<leader>cl`（Claude Code CLI）。

**如何更新設定**

```bash
git pull
```

插件版本鎖定於 `nvim-pack-lock.json`（`vim.pack` 的 lockfile）；若要更新插件本身版本，依 `vim.pack` 的更新指令操作（例如 `:lua vim.pack.update()`，實際指令請以你當時使用的 Neovim 版本文件為準）。

---

## 12. 維護與擴充

新增插件或修改 keymap 後，請同步更新以下區塊，避免 README 與實際設定脫節：

1. **新增插件時**
   - 在 [3. 插件清單](#3-插件清單) 加一列（功能／原因／角色／依賴／使用場景）。
   - 若插件有自帶按鍵，補進 [5. 插件預設 keybinding](#5-插件預設-keybinding)；若是本設定自訂的鍵，補進 [6. 自訂 keybinding](#6-自訂-keybinding)。
   - 同步更新 [7. 插件與 keybinding 對照表](#7-插件與-keybinding-對照表) 與必要時的 [10. Cheat Sheet](#10-cheat-sheet)。
   - 檢查新按鍵是否與既有的 `<leader>*`／`g*`／`[`/`]` 系列鍵衝突，若有請補進 [8. 已知的按鍵重疊 / 覆蓋](#8-已知的按鍵重疊--覆蓋)。

2. **新增/移除 `mini.nvim` 子模組時**
   - 記得同時修改 `lua/plugins/mini.lua` 的 `require` 清單（否則檔案存在但不生效，如目前 11 個未載入的子模組）。
   - 更新 [4. mini.nvim 子模組](#4-mininvim-子模組) 表格的載入狀態。

3. **移除插件時**
   - 從 `lua/plugins/*.lua` 刪除對應檔案並從本文件所有表格中移除該列，包含 Cheat Sheet 與對照表。

4. **避免脫節的建議**
   - 每次修改 `lua/plugins/**` 或 `lua/lsp/**` 後，順手 `grep -rn "keymap.set\|keys *="  lua/` 核對一次目前所有實際生效的按鍵，跟本文件表格比對。
   - 若之後改回集中式 `lua/keybinding.lua`（目前已刪除，改為按插件分散管理），請同步調整本文件「自訂 keybinding」小節的檔案來源說明。
   - 保留本文件的表格式結構（而非改寫成長文字敘述），方便日後用腳本或 diff 快速核對是否有遺漏。
