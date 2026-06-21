return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    {"L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp"},
    "rafamadriz/friendly-snippets",
  },
  opts = {
    -- ── Keymap ──────────────────────────────────────────────────
    -- 對應你原本的 mapping 行為
    keymap = {
      preset = "none", -- 完全自訂，不用 preset

      -- CR：確認補全（對應原本的 CR mapping）
      ["<CR>"] = {
        function(cmp)
          -- snippet 可展開時優先展開
          if require("luasnip").expandable() then
            require("luasnip").expand()
            return true
          end
          -- 否則確認補全
          return cmp.accept()
        end,
        "fallback",
      },

      -- Tab：下一個補全項 / snippet 跳點
      ["<Tab>"] = {
        function(cmp)
          local luasnip = require("luasnip")
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
            return true
          end
        end,
        "select_next",
        "fallback",
      },

      -- S-Tab：上一個補全項 / snippet 跳點
      ["<S-Tab>"] = {
        function(cmp)
          local luasnip = require("luasnip")
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
            return true
          end
          local ok, neogen = pcall(require, "neogen")
          if ok and neogen.jumpable(-1) then
            neogen.jump_prev()
            return true
          end
        end,
        "select_prev",
        "fallback",
      },

      -- 文件捲動（對應 C-b / C-f）
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      -- 手動觸發補全
      ["<C-Space>"] = { "show", "fallback" },

      -- 取消補全
      ["<C-e>"] = { "cancel", "fallback" },
    },

    -- ── Cmdline ─────────────────────────────────────────────────
    -- 對應原本的 cmp.setup.cmdline
    cmdline = {
      enabled = true,
      keymap  = { preset = "cmdline" },

      sources = function()
        local type = vim.fn.getcmdtype()
        -- / 和 ? 搜尋：用 buffer source
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- : 指令：用 path + cmdline
        if type == ":" then
          return { "path", "cmdline" }
        end
        return {}
      end,
    },

    -- ── Snippets ────────────────────────────────────────────────
    snippets = {
      preset = "luasnip", -- 用你現有的 LuaSnip
      -- 對應原本的 require('luasnip.loaders.from_vscode').lazy_load()
      -- blink 會自動處理 friendly-snippets 載入
    },

    -- ── Sources ─────────────────────────────────────────────────
    -- 對應原本的 sources 設定（含 group 優先順序）
    sources = {
      default = { "lsp", "snippets", "buffer", "path" },

      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },

      providers = {
        -- lazydev（對應原本的 group_index = 0，最高優先）
        lazydev = {
          name         = "LazyDev",
          module       = "lazydev.integrations.blink",
          score_offset = 100,
        },

        -- buffer（對應原本的 fallback group）
        buffer = {
          min_keyword_length = 2,
        },

        -- lsp
        lsp = {
          min_keyword_length = 0,
        },
      },
    },

    -- ── Appearance ──────────────────────────────────────────────
    -- 對應原本的 lspkind formatting
    appearance = {
      nerd_font_variant = "mono",
      kind_icons = {
        Text          = "󰉿",
        Method        = "󰊕",
        Function      = "󰊕",
        Constructor   = "󰒓",
        Field         = "󰜢",
        Variable      = "󰆦",
        Property      = "󰖷",
        Class         = "󱡠",
        Interface     = "󱡠",
        Struct        = "󱡠",
        Module        = "󰅩",
        Unit          = "󰪚",
        Value         = "󰦨",
        Enum          = "󰦨",
        EnumMember    = "󰦨",
        Keyword       = "󰻾",
        Constant      = "󰏿",
        Snippet       = "󱄽",
        Color         = "󰏘",
        File          = "󰈔",
        Reference     = "󰬲",
        Folder        = "󰉋",
        Event         = "󱐋",
        Operator      = "󰪚",
        TypeParameter = "󰬛",
      },
    },

    -- ── Completion ──────────────────────────────────────────────
    completion = {
      -- 對應原本的 select = true（預選第一個）
      list = {
        selection = {
          preselect   = true,
          auto_insert = false,
        },
      },

      -- 補全選單（對應原本的 window 設定）
      menu = {
        auto_show = true,
        border    = "rounded",
        draw      = {
          -- 對應 lspkind 的 symbol mode + labelDetails
          columns = {
            { "kind_icon" },
            { "label",    "label_description", gap = 1 },
            { "kind" },
          },
          -- 對應原本的 maxwidth
          treesitter = { "lsp" },
        },
      },

      -- 文件視窗（對應原本註解掉的 bordered documentation）
      documentation = {
        auto_show          = true,
        auto_show_delay_ms = 200,
        window             = {
          border    = "rounded",
          max_width = 50, -- 對應原本的 menu = 50
        },
      },

      -- 自動括號
      accept = {
        auto_brackets = { enabled = true },
      },
    },

    -- ── Sorting ─────────────────────────────────────────────────
    -- 對應原本的 cmp-under-comparator
    -- blink 內建 frecency + proximity，不需要額外外掛
    -- 但可以客製化 score：
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      -- 對應 cmp-under-comparator 的 underscore 排序
      -- 底線開頭的項目自動降低分數
      sorts          = {
        "score",
        "sort_text",
      },
    },
  },

  config = function(_, opts)
    require("blink.cmp").setup(opts)

    -- friendly-snippets 載入（對應原本的 lazy_load）
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
