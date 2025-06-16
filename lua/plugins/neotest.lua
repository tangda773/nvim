return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    -- This plugin is not needed after neovim/neovim#20198
    -- "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    -- adapters
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "alfaix/neotest-gtest",
    {"nvim-neotest/neotest-vim-test", dependencies ={"vim-test/vim-test"}}
  },

  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python"),
        require("neotest-plenary"),
        require("neotest-gtest").setup({}),
        require("neotest-vim-test")({ignore_filetpes={"python","lua","cpp"}}),
      }
    })
  end,
  keys = {
    {"<leader>tr", ":lua require(\"neotest\").run.run()<cr>", desc="Neotest Run Current Test"},
    {"<leader>tf", ":lua require(\"neotest\").run.run(vim.fn.expand(\"%\"))<cr>", desc="Neotest Run Current File"},
    {"<leader>td", ":lua require(\"neotest\").run.run({strategy=\"dap\"})<cr>", desc="Neotest Debug Current Test"},
    {"<leader>ts", ":lua require(\"neotest\").run.stop()<cr>", desc="Neotest Stop Current Test"},
    {"<leader>ta", ":lua require(\"neotest\").run.attach()<cr>", desc="Neotest Attach Current Test"},
  }
}
