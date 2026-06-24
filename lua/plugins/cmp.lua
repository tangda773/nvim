return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
    "rafamadriz/friendly-snippets",
  },
  opts = {
    -- ── Keymap ──────────────────────────────────────────────────
    keymap = {
      preset        = "none",
      -- CR：只負責確認補全，LuaSnip expand 移到外面的 vim.keymap
      ["<CR>"]      = { "accept", "fallback" },
      -- Tab：只負責補全選單導航，snippet jump 移到外面的 vim.keymap
      ["<Tab>"]     = { "select_next", "fallback" },
      ["<S-Tab>"]   = { "select_prev", "fallback" },
      -- 文件捲動
      ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
      ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
      -- 手動觸發補全
      ["<C-Space>"] = { "show", "fallback" },
      -- 取消補全
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
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        lazydev = {
          name         = "LazyDev",
          module       = "lazydev.integrations.blink",
          score_offset = 100,
        },
        buffer = {
          min_keyword_length = 2,
        },
        lsp = {
          min_keyword_length = 0,
        },
      },
    },
    -- ── Appearance ──────────────────────────────────────────────
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
            { "label",    "label_description", gap = 1 },
            { "kind" },
          },
          treesitter = { "lsp" },
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

    -- friendly-snippets 載入
    require("luasnip.loaders.from_vscode").lazy_load()

    local luasnip = require("luasnip")

    -- Tab：snippet jump forward（在 blink menu 關閉後才觸發）
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
          "n", false
        )
      end
    end, { silent = true, desc = "LuaSnip jump forward / Tab" })

    -- S-Tab：snippet jump backward
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true),
          "n", false
        )
      end
    end, { silent = true, desc = "LuaSnip jump backward / S-Tab" })

    -- CR：snippet expand（menu 沒開時才需要這個）
    vim.keymap.set("i", "<CR>", function()
      if luasnip.expandable() then
        luasnip.expand()
      else
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<CR>", true, false, true),
          "n", false
        )
      end
    end, { silent = true, desc = "LuaSnip expand / CR" })
  end,
}
