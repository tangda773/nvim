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
    "fredrikaverpil/neotest-golang", -- Go
    "nvim-neotest/neotest-jest",     -- TypeScript/JavaScript (Jest)
    "marilari88/neotest-vitest",     -- 如果專案用 Vitest 而非 Jest，改用/並用這個
  },
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end,                     desc = "[Test] Run" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "[Test] Run file" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "[Test] Debug" },
    { "<leader>ts", function() require("neotest").run.stop() end,                    desc = "[Test] Stop" },
    { "<leader>ta", function() require("neotest").run.attach() end,                  desc = "[Test] Attach" },
    { "<leader>to", function() require("neotest").output_panel.toggle() end,         desc = "[Test] Output" },
    { "<leader>tS", function() require("neotest").summary.toggle() end,              desc = "[Test] Summary" },
  },
  opts = function()
    local adapters = {
      require("neotest-python"),
      require("neotest-plenary"),
      require("neotest-gtest").setup({}),
      require("neotest-golang")({
        go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
      }),
      require("neotest-jest")({
        jestCommand = "npm test --",
        jestConfigFile = "jest.config.js",
        env = { CI = true },
        cwd = function()
          return vim.fn.getcwd()
        end,
      }),
      require("neotest-vitest"),
      require("neotest-vim-test")({
        ignore_filetypes = { "python", "lua", "cpp", "go", "javascript", "typescript", "javascriptreact", "typescriptreact" },
      }),
    }
    local ok, rust_adapter = pcall(require, "rustaceanvim.neotest")
    if ok then
      table.insert(adapters, rust_adapter)
    end
    return { adapters = adapters }
  end,
}
