return {
  "mistricky/codesnap.nvim",
  keys = {
    {
      "<leader>cs",
      function() require("codesnap").copy() end,
      mode = "v",
      desc = "[Code] Snap and copy",
    },
    {
      "<leader>cS",
      function()
        require("codesnap").save(vim.fn.expand("~/Pictures/codesnap") .. "/snap-" .. os.date("%Y%m%d-%H%M%S") .. ".png")
      end,
      mode = "v",
      desc = "[Code] Snap and save",
    },
  },
  opts = {
    save_path = vim.fn.expand("~/Pictures/codesnap"),
  },
}
