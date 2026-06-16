return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function(_, opts)
    require('gitsigns').setup(opts)
  end,
  opts = {},
}
