-- lua/plugins/orgmode.lua
return {
  "nvim-orgmode/orgmode",
  event  = "VeryLazy",
  config = function()
    require("orgmode").setup({
      -- ── 基本路徑 ────────────────────────────
      org_agenda_files  = {
        "~/notes/**/*.org",
        "~/notes/*.org",
      },
      org_default_notes_file = "~/notes/inbox.org",

      -- ── TODO states ─────────────────────────
      org_todo_keywords = {
        "TODO(t)",
        "NEXT(n)",
        "WAIT(w)",
        "|",
        "DONE(d)",
        "CANCELLED(c)",
      },

      -- ── Tags ────────────────────────────────
      org_tags_column = -80,

      -- ── Capture templates ───────────────────
      org_capture_templates = {
        t = {
          description = "Todo",
          template    = "* TODO %?\n  %u",
          target      = "~/notes/inbox.org",
        },
        n = {
          description = "Note",
          template    = "* %?\n  %u",
          target      = "~/notes/inbox.org",
        },
        j = {
          description = "Journal",
          template    = "* %<%Y-%m-%d %a>\n** %<%H:%M> %?",
          target      = "~/notes/journal/%<%Y-%m>.org",
          datetree    = { tree_type = "month" },
        },
        w = {
          description = "Work Todo",
          template    = "* TODO %? :work:\n  DEADLINE: %^{Deadline}t",
          target      = "~/notes/work/inbox.org",
        },
        c = {
          description = "Code snippet",
          template    = "* %^{Title} :code:\n#+begin_src %^{Language}\n%?\n#+end_src\n  %u",
          target      = "~/notes/snippets.org",
        },
      },

      -- ── UI ──────────────────────────────────
      org_startup_folded     = "showeverything",
      org_ellipsis           = " ▼",
      org_hide_leading_stars = true,

      -- ── 日期格式 ────────────────────────────
      org_time_stamp_rounding_minutes = 5,
    })
  end,
}
