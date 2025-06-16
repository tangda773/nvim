return{
  {
        "mfussenegger/nvim-dap",
        lazy=true,
        config = function()
          vim.keymap.set("n","<F5>",function() require("dap").continue() end, {desc="Dap Continue"})
          vim.keymap.set("n","<F10>",function() require("dap").step_over() end, {desc="Dap Step Over"})
          vim.keymap.set("n","<F11>",function() require("dap").step_into() end, {desc="Dap Step Into"})
          vim.keymap.set("n","<F12>",function() require("dap").step_out() end, {desc="Dap Step out"})
          vim.keymap.set("n","<leader>b",function() require("dap").toggle_breakpoint() end, {desc="Dap Toggle Breakpoint"})
          vim.keymap.set("n","<leader>B",function() require("dap").set_breakpoint() end, {desc="Dap Set Breakpoint"})
          vim.keymap.set("n","<leader>lp",function() require("dap").set_breakpoint(nil,nil,vim.fn.input('Log point message: ')) end, {desc="Dap Set Breakpoint and Log Message"})
          vim.keymap.set("n","<leader>dr",function() require("dap").repl.open() end, {desc="Dap Repl Open"})
          vim.keymap.set("n","<leader>dl",function() require("dap").run_last() end, {desc="Dap Run Last"})
        end,
        init = function()
            vim.api.nvim_create_user_command("DapStart", function()
              vim.cmd("doautocmd User DapDebugStarted")
            end, {})
        end
  },
  {
      "rcarriga/nvim-dap-ui",
      event = "User DapDebugStarted",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        {"folke/lazydev.nvim", opts={library = {"nvim-dap-ui"}}},
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
        vim.keymap.set({"n","v"},"<leader>dh", function() dapui.widgets.hover() end,{desc="Dap Widgets Hover"})
        vim.keymap.set({"n","v"},"<leader>dp", function() dapui.widgets.preview() end,{desc="Dap Widgets Preview"})
        vim.keymap.set("n","<leader>df", function() dapui.widgets.centered_float(dapui.widgets.frame) end,{desc="Dap Widgets Frames"})
        vim.keymap.set("n","<leader>ds", function() dapui.widgets.centered_float(dapui.widgets.scopes) end,{desc="Dap Widgets Scopes"})

        end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "User DapDebugStarted",
    dependencies = {
      {"williamboman/mason.nvim"},
      {"mfussenegger/nvim-dap"},
    },
    opts = {
        ensure_installed = {},
        handlers = {}
    }
  }
}
