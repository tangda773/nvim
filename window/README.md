# Windows Config

這個目錄用來集中管理 Windows 開發環境的使用者設定，採用接近 XDG 的結構，方便版本控管、重裝還原與跨機同步。

目前主要涵蓋以下幾類設定：

- 視窗管理：`komorebi`
- 快捷鍵：`whkdrc`
- 終端機：`wezterm`
- Prompt：`starship.toml`
- 套件管理：`scoop`
- 代理：`clash`
- 筆記：`joplin-desktop`
- 容器相關：`containers`

## Layout

```text
.config/
├─ clash/
├─ containers/
├─ joplin-desktop/
├─ komorebi/
├─ scoop/
├─ starship.toml
├─ wezterm/
└─ whkdrc
```

## Components

### komorebi

Windows tiling window manager 設定目錄。

用途包括：

- workspace / monitor 配置
- layout 規則
- window matching / float 規則
- bar 相關設定（若有使用）

### whkdrc

`whkd` 的快捷鍵設定檔。

主要負責：

- 定義全域快捷鍵
- 呼叫 `komorebic` 控制視窗行為
- 重載或切換 komorebi 工作流

### wezterm

WezTerm 終端機設定目錄。

通常包含：

- 字型與配色
- tab / pane 行為
- 快捷鍵
- WSL / PowerShell / SSH 啟動設定

### starship.toml

Starship prompt 設定檔。

主要控制：

- prompt 樣式
- Git 狀態顯示
- 語言 / runtime 模組顯示
- WSL / shell 相關提示資訊

### scoop

Scoop 套件管理器相關設定。

可能包含：

- bucket 配置
- 安裝來源偏好
- 使用習慣相關設定

### clash

Clash 代理工具相關設定。

通常用於：

- proxy profile
- rule / routing 設定
- 工作與個人環境切換

### joplin-desktop

Joplin Desktop 設定與 profile 資料目錄。

### containers

容器工具相關設定，可能用於保存 Docker / Podman / dev container 類型的個人配置。

## Design Notes

這份設定的核心目標：

- 用 Git 管理 Windows 個人環境
- 降低重裝與換機成本
- 讓視窗管理、終端機、Prompt 與工具鏈設定集中化
- 保持與 Linux / Neovim / shell dotfiles 類似的管理方式

## Bootstrap

在新環境初始化時，通常需要確認以下項目：

1. 安裝必要工具：
   - `komorebi`
   - `whkd/autohotkey`
   - `wezterm`
   - `starship`
   - `scoop`
   - `clash`（若需要）
   - `joplin`（若需要）

2. 確認設定檔位置：
   - `KOMOREBI_CONFIG_HOME`
   - `WHKD_CONFIG_HOME`
   - `STARSHIP_CONFIG`

3. 建立啟動流程：
   - 登入後啟動 `komorebi`
   - 啟動 `whkd/autohotkey script`
   - 套用 shell / terminal 設定
