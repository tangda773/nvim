local lspkind = require("lspkind")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

cmp.setup({
  -- 指定 snippet 引擎
  snippet = {
    expand = function(args)
      -- For `vsnip` users.
      -- vim.fn["vsnip#anonymous"](args.body)

      -- For `luasnip` users.
      require("luasnip").lsp_expand(args.body)

      -- For `ultisnips` users.
      -- vim.fn["UltiSnips#Anon"](args.body)

      -- For `snippy` users.
      -- require'snippy'.expand_snippet(args.body)
    end,
  },
  -- 来源
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    -- { name = "vsnip" }, -- For vsnip users.
    { name = "luasnip" }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = "nvim_lua" },
    { name = "path" },
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require("cmp-under-comparator").under,
      cmp.config.compare.kind,
      cmp.config.compare.sore_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  -- 快捷键
  mapping = require("keybindings").cmp(cmp),
  -- 使用lspkind-nvim顯示類型圖標
  formatting = {
    format = lspkind.cmp_format({
      with_text = true, -- do not show text alongside icons
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      before = function(entry, vim_item)
        -- Source 顯示提示来源
        vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
        return vim_item
      end,
    }),
  },
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
  }, {
    { name = "cmdline" },
  }),
})

-- Only enable `lua-latex-symbols` for `tex` and `plaintex` and `markdown` file types
cmp.setup.filetype({ "toml" }, {
  sources = {
    { name = "crates" },
  },
})

-- Only enable `lua-latex-symbols` for `tex` and `plaintex` and `markdown` file types
cmp.setup.filetype({ "tex", "plaintex", "markdown" }, {
  sources = {
    { name = "lua-latex-symbols" },
  },
})

-- If you want insert `(` after select function or method item
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
