return{
  {
  "echasnovski/mini.nvim",
  config = function()
    vim.cmd([[colorscheme randomhue]])

    -- Text editing
    require("plugins.mini.ai")
    require("plugins.mini.align")
    require("plugins.mini.comment")
    -- require("plugins.mini.completion")
    require("plugins.mini.keymap")
    require("plugins.mini.move")
    require("plugins.mini.operators")
    require("plugins.mini.pairs")
    -- require("plugins.mini.snippets")
    require("plugins.mini.splitjoin")
    require("plugins.mini.surround")

    -- General workflow
    require("plugins.mini.basics")
    require("plugins.mini.bracketed")
    require("plugins.mini.bufremove")
    -- require("plugins.mini.clue")
    -- require("plugins.mini.deps")
    require("plugins.mini.diff")
    require("plugins.mini.extra")
    -- require("plugins.mini.files")
    require("plugins.mini.git")
    require("plugins.mini.jump")
    require("plugins.mini.jump2d")
    require("plugins.mini.misc")
    -- require("plugins.mini.pick")
    require("plugins.mini.sessions")
    require("plugins.mini.visits")

    -- Appearance
    -- require("plugins.mini.animate")
    -- require("plugins.mini.base16")
    require("plugins.mini.colors")
    require("plugins.mini.cursorword")
    require("plugins.mini.hipatterns")
    -- require("plugins.mini.hues")
    require("plugins.mini.icons")
    require("plugins.mini.indentscope")
    require("plugins.mini.map")
    -- require("plugins.mini.notify")
    require("plugins.mini.starter")
    require("plugins.mini.statusline")
    require("plugins.mini.tabline")
    require("plugins.mini.trailspace")

    -- Other
    -- require("plugins.mini.doc")
    -- require("plugins.mini.fuzzy")
    -- require("plugins.mini.test")
  end,
  },
  {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.nvim",
      },
      config = function()
          local spec_treesitter = require('mini.ai').gen_spec.treesitter
            require('mini.ai').setup({
              custom_textobjects = {
                -- a = spec_treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
                c = spec_treesitter({ a = '@class.outer', i = '@class.inner' }),
                F = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
                -- F = spec_treesitter({ a = '@call.outer', i = '@call.inner' }),
                o = spec_treesitter({
                  a = {'@loop.outer', '@conditional.outer'},
                  i = {'@loop.inner','@conditional.inner' },
                })
              }
            })
      end,
  }
}
