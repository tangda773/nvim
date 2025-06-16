return {
  "t-troebst/perfanno.nvim",
  opts = function()
      local util = require("perfanno.util")
      return {
        line_highlights = util.make_bg_highlights(nil, "#CC3300", 10),
        vt_highlight = util.make_fg_highlight("#CC3300"),
      }
    end,
  -- keys = {
  --   {"<leader>plf",":PerfLoadFlat<cr>", desc="PerfLoadFlat"},
  --   {"<leader>plg",":PerfLoadCallGraph<cr>", desc="PerfLoadCallGraph"},
  --   {"<leader>plo",":PerfLoadFrameGraph<cr>", desc="PerfLoadFrameGraph"},
  --   {"<leader>pe",":PerfPickEvent<cr>", desc="PerfPickEvent"},
  --   {"<leader>pa",":PerfAnnotate<cr>", desc="PerfAnnotate"},
  --   {"<leader>pf",":PerfAnnotateFunction<cr>", desc="PerfAnnotateFunction"},
  --   {"<leader>pa",":PerfAnnotateSelection<cr>",mode="v", desc="PerfAnnotateSelection"},
  --   {"<leader>pa",":PerfToggleAnnotations<cr>", desc="PerfToggleAnnotations"},
  --   {"<leader>ph",":PerfHottestLines<cr>", desc="PerfHottestLines"},
  --   {"<leader>ps",":PerfHottestSymbols<cr>", desc="PerfHottestSymbols"},
  --   {"<leader>pc",":PerfHottestCallersFunction<cr>", desc="PerfHottestCallersFunction"},
  --   {"<leader>pc",":PerfHottestCallersSelection<cr>",mode="v", desc="PerfHottestCallersSelection"},
  -- },
  lazy = true,
}
