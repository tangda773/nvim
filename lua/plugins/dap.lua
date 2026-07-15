return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    init = function()
      vim.api.nvim_create_user_command("DapStart", function()
        vim.cmd("doautocmd User DapDebugStarted")
      end, {})
    end,
    keys = {
      { "<F5>",       function() require("dap").continue() end,                                      desc = "Dap: continue" },
      { "<F10>",      function() require("dap").step_over() end,                                     desc = "Dap: step over" },
      { "<F11>",      function() require("dap").step_into() end,                                     desc = "Dap: step into" },
      { "<F12>",      function() require("dap").step_out() end,                                      desc = "Dap: step out" },
      { "<leader>b",  function() require("dap").toggle_breakpoint() end,                             desc = "Dap: toggle breakpoint" },
      { "<leader>B",  function() require("dap").set_breakpoint() end,                                desc = "Dap: set breakpoint" },
      { "<leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: ")) end, desc = "Dap: log point" },
      { "<leader>dr", function() require("dap").repl.open() end,                                     desc = "Dap: repl" },
      { "<leader>dl", function() require("dap").run_last() end,                                      desc = "Dap: run last" },
    },
    cmd = { "DapContinue", "DapToggleBreakpoint" },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "User DapDebugStarted",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      { "folke/lazydev.nvim", opts = { library = { "nvim-dap-ui" } } },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup({})
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      vim.keymap.set({ "n", "v" }, "<leader>dh", function() dapui.widgets.hover() end, { desc = "Dap Widgets Hover" })
      vim.keymap.set({ "n", "v" }, "<leader>dp", function() dapui.widgets.preview() end, { desc = "Dap Widgets Preview" })
      vim.keymap.set("n", "<leader>df", function() dapui.widgets.centered_float(dapui.widgets.frame) end,
        { desc = "Dap Widgets Frames" })
      vim.keymap.set("n", "<leader>ds", function() dapui.widgets.centered_float(dapui.widgets.scopes) end,
        { desc = "Dap Widgets Scopes" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "User DapDebugStarted",
    dependencies = {
      { "mason-org/mason.nvim" },
      { "mfussenegger/nvim-dap" },
    },
    opts = {
      ensure_installed = {},
      handlers = {}
    }
  }
}
