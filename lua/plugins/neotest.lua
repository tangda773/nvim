return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- adapters
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "alfaix/neotest-gtest",
    { "nvim-neotest/neotest-vim-test", dependencies = { "vim-test/vim-test" } },
    "mrcjkb/rustaceanvim",
  },
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end,                     desc = "Neotest: run" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Neotest: run file" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Neotest: debug" },
    { "<leader>ts", function() require("neotest").run.stop() end,                    desc = "Neotest: stop" },
    { "<leader>ta", function() require("neotest").run.attach() end,                  desc = "Neotest: attach" },
    { "<leader>to", function() require("neotest").output_panel.toggle() end,         desc = "Neotest: output" },
    { "<leader>tS", function() require("neotest").summary.toggle() end,              desc = "Neotest: summary" },
  },
  opts = function()
    return {
      adapters = {
        require("neotest-python"),
        require("neotest-plenary"),
        require("neotest-gtest").setup({}),
        require("neotest-vim-test")({ ignore_filetypes = { "python", "lua", "cpp" } }),
        require("rustaceanvim.neotest"),
      },
    }
  end,
}
