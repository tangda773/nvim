-- ~/.config/nvim/lua/config/orgmode-settings.lua
local M = {}

M = {
  -- ═══════════════════════════════════════════════
  -- 📁 檔案路徑
  -- ═══════════════════════════════════════════════
  org_agenda_files = {
    "~/org/**/*",
  },
  org_default_notes_file = "~/org/inbox.org",

  -- ═══════════════════════════════════════════════
  -- 📋 Capture Templates
  -- 先保留最常用、最穩定的 4 組：
  -- inbox / journal / task / code-note
  -- 其他像 meeting / reference / next action
  -- 建議後續 workflow 穩定後再加
  -- ═══════════════════════════════════════════════
  org_capture_templates = {
    i = {
      description = "Inbox",
      template = "* TODO %?\n  %U\n  %a",
      target = "~/org/inbox.org",
    },

    j = {
      description = "Journal",
      template = "\n*** %<%H:%M> %?\n",
      target = "~/org/journal.org",
      datetree = { date_only = false },
    },

    t = {
      description = "Task",
      template = "* TODO %^{Task title}\n  SCHEDULED: %^t\n  :PROPERTIES:\n  :PROJECT: %^{Project name}\n  :END:\n  %?",
      target = "~/org/projects.org",
    },

    c = {
      description = "Code Note",
      template =
      "* %^{Title}\n  %U\n  :PROPERTIES:\n  :LANG: %^{rust|lua|c|bash|python}\n  :END:\n\n#+begin_src %\\3\n%?\n#+end_src\n",
      target = "~/org/code-notes.org",
    },
  },

  -- ═══════════════════════════════════════════════
  -- ✅ TODO 狀態機
  -- 左邊 = 未完成；右邊 = 完成
  -- ═══════════════════════════════════════════════
  org_todo_keywords = {
    "TODO(t)",
    "NEXT(n)",
    "IN-PROGRESS(i)",
    "WAITING(w)",
    "SOMEDAY(s)",
    "|",
    "DONE(d)",
    "CANCELLED(c)",
    "DELEGATED(g)",
  },

  -- 若你的 colorscheme 對自訂 face 支援不穩，
  -- 可先整段拿掉；這裡只保留低風險、辨識度高的幾個
  org_todo_keyword_faces = {
    TODO = ":foreground #ff6b6b :weight bold",
    NEXT = ":foreground #ffd93d :weight bold",
    WAITING = ":foreground #4d96ff :weight bold",
    DONE = ":foreground #6bcb77 :weight bold",
    CANCELLED = ":foreground #777777 :slant italic",
  },

  -- ═══════════════════════════════════════════════
  -- 🏷 Tag
  -- ═══════════════════════════════════════════════
  org_tags_column = -80,
  org_tag_persistent_action = true,

  -- ═══════════════════════════════════════════════
  -- 📅 Agenda
  -- ═══════════════════════════════════════════════
  org_agenda_span = "week",
  org_agenda_start_on_weekday = 1,
  org_deadline_warning_days = 7,
  org_agenda_skip_scheduled_if_done = true,
  org_agenda_skip_deadline_if_done = true,

  -- 可選：如果你真的想看更乾淨 agenda 再打開
  -- org_agenda_remove_tags = true,

  -- ═══════════════════════════════════════════════
  -- 📝 日誌記錄
  -- ═══════════════════════════════════════════════
  org_log_done = "time",
  org_log_repeat = "time",
  org_log_into_drawer = "LOGBOOK",

  -- ═══════════════════════════════════════════════
  -- 🖼 顯示
  -- ═══════════════════════════════════════════════
  org_startup_folded = "overview",
  org_startup_indented = true,
  org_hide_leading_stars = true,
  org_hide_emphasis_markers = true,
  org_ellipsis = " ⤵",

  -- ═══════════════════════════════════════════════
  -- 🪟 視窗
  -- float 視窗是官方支援的穩定配置之一
  -- ═══════════════════════════════════════════════
  win_split_mode = { "float", 0.8 },
  win_border = "rounded",
}

return M
