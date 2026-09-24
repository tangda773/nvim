return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = "screen"
  end,
  opts = function(_, opts)
    for _, pos in ipairs({ "bottom", "right" }) do
      opts[pos] = opts[pos] or {}
      table.insert(opts[pos], {
        ft = "snacks_terminal",
        size = pos == "bottom" and { height = 0.25 } or { width = 0.33 },
        title = "%{b:snacks_terminal.id}: %{b:term_title}",
        filter = function(_buf, win)
          return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == pos
              and vim.w[win].snacks_win.relative == "editor"
        end,
      })
    end
  end,
}
