return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    { "L3MON4D3/LuaSnip",           version = "v2.*", build = "make install_jsregexp" },
    "rafamadriz/friendly-snippets",
    { "saghen/blink.compat" },
    { "hrsh7th/cmp-nvim-lua" },
    { "samiulsami/cmp-go-deep" },
    { "ray-x/cmp-sql" },
    { "archie-judd/blink-cmp-words" },
  },
  opts = {
    -- ── Keymap ──────────────────────────────────────────────────
    keymap = {
      preset        = "none",
      ["<CR>"]      = { "accept", "fallback" },
      ["<Tab>"]     = { "select_next", "fallback" },
      ["<S-Tab>"]   = { "select_prev", "fallback" },
      ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
      ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "fallback" },
      ["<C-e>"]     = { "cancel", "fallback" },
    },
    -- ── Cmdline ─────────────────────────────────────────────────
    cmdline = {
      enabled = true,
      keymap  = { preset = "cmdline" },
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then return { "buffer" } end
        if type == ":" then return { "path", "cmdline" } end
        return {}
      end,
    },
    -- ── Snippets ────────────────────────────────────────────────
    snippets = {
      preset = "luasnip",
    },
    -- ── Sources ─────────────────────────────────────────────────
    sources = {
      default = { "lsp", "snippets", "buffer", "path" },
      per_filetype = {
        lua       = { inherit_defaults = true, "lazydev", "nvim_lua" },
        go        = { inherit_defaults = true, "go_deep" },
        sql       = { "snippets", "dadbod", "sql", "buffer" },
        mysql     = { "snippets", "dadbod", "sql", "buffer" },
        plsql     = { "snippets", "dadbod", "sql", "buffer" },
        markdown  = { inherit_defaults = true, "thesaurus" },
        gitcommit = { inherit_defaults = true, "thesaurus" },
      },
      providers = {
        lazydev   = {
          name         = "LazyDev",
          module       = "lazydev.integrations.blink",
          score_offset = 100,
        },
        buffer    = {
          min_keyword_length = 2,
        },
        lsp       = {
          min_keyword_length = 0,
        },
        nvim_lua  = {
          name = "nvim_lua",
          module = "blink.compat.source"
        },
        go_deep   = {
          name = "go_deep",
          module = "blink.compat.source"
        },
        dadbod    = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        sql       = { name = "sql", module = "blink.compat.source" },
        thesaurus = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.thesaurus",
          opts = {
            score_offset = 0,
            definition_pointers = { "!", "&", "^" }, -- antonyms, similar to, also see
          },
        },
      },
    },
    -- ── Signature ─────────────────────────────────────────────────
    signature = { enabled = true },
    -- ── Appearance ──────────────────────────────────────────────
    appearance = {
      nerd_font_variant = "mono",
    },
    -- ── Completion ──────────────────────────────────────────────
    completion = {
      list = {
        selection = {
          preselect   = true,
          auto_insert = false,
        },
      },
      menu = {
        auto_show = true,
        border    = "rounded",
        draw      = {
          columns = {
            { "kind_icon" },
            { "label",       "label_description", gap = 1 },
            { "kind" },
            { "source_name", gap = 1 },
          },
          treesitter = { "lsp" },
          components = {
            -- ── 圖示：mini.icons 動態取得，純文字色 ────────────
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local icon, _, _ = require("mini.icons").get("lsp", ctx.kind:lower())
                return icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind:lower())
                return hl
              end,
            },

            -- ── kind：純文字，不加括號 ─────────────────────
            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx) return ctx.kind end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind:lower())
                return hl
              end,
            },

            -- ── label：fuzzy 匹配加粗 + deprecated 刪除線 ──────
            label = {
              width = { fill = true, max = 60 },
              text = function(ctx)
                return ctx.label .. (ctx.label_detail or "")
              end,
              highlight = function(ctx)
                if ctx.deprecated then
                  local highlights = {
                    { 0, #ctx.label, group = "BlinkCmpLabelDeprecated" },
                  }
                  for _, idx in ipairs(ctx.label_matched_indices or {}) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  return highlights
                end

                local highlights = {
                  { 0, #ctx.label, group = "BlinkCmpLabel" },
                }
                if ctx.label_detail then
                  table.insert(highlights, {
                    #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail",
                  })
                end
                for _, idx in ipairs(ctx.label_matched_indices or {}) do
                  table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                end
                return highlights
              end,
            },
            label_description = {
              ellipsis  = true,
              width     = { max = 25 },
              text      = function(ctx) return ctx.label_description end,
              highlight = "BlinkCmpLabelDescription",
            },

            -- ── 來源：方括號淡色文字，常駐顯示 ─────────────
            source_name = {
              text = function(ctx)
                return "[" .. ctx.source_name .. "]"
              end,
              highlight = "BlinkCmpSource",
            },
          },
        },
      },
      documentation = {
        auto_show          = true,
        auto_show_delay_ms = 200,
        window             = {
          border    = "rounded",
          max_width = 50,
        },
      },
      accept = {
        auto_brackets = { enabled = true },
      },
    },
    -- ── Sorting ─────────────────────────────────────────────────
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts          = { "score", "sort_text" },
    },
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    require("luasnip.loaders.from_vscode").lazy_load()

    local luasnip = require("luasnip")

    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
          "n", false
        )
      end
    end, { silent = true, desc = "Snippet jump forward" })

    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true),
          "n", false
        )
      end
    end, { silent = true, desc = "Snippet jump backward" })

    vim.keymap.set("i", "<CR>", function()
      if luasnip.expandable() then
        luasnip.expand()
      else
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<CR>", true, false, true),
          "n", false
        )
      end
    end, { silent = true, desc = "Snippet expand" })

    -- ── Fuzzy 匹配字元顏色 ───────────────────────────────
    vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#FFD866", bold = true })

    -- ── Deprecated：純色繼承 + 刪除線 ─────────────────────
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { link = "Comment" })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { strikethrough = true })

    -- ── 來源標籤：低調灰色，比 kind 文字更淡 ────────────────
    vim.api.nvim_set_hl(0, "BlinkCmpSource", { link = "Comment" })
  end,
}
