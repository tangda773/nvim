return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")

      -- 修正:原本 DapDebugStarted 只有靠一個沒人呼叫的 :DapStart 指令觸發,
      -- dap-ui / mason-nvim-dap 永遠不會被載入。改成掛在 dap 自己的
      -- listener 上,不管用 <F5> 還是任何指令啟動 session 都會自動 fire。
      dap.listeners.before.event_initialized["_zpack_dap_debug_started"] = function()
        vim.cmd("doautocmd User DapDebugStarted")
      end

      -- ⚠️ 如果第一次按 <F5> 時 dap-ui 沒自動跳出來(只有第二次之後才正常),
      -- 代表 event_initialized 這個時機點對這次冷啟動來說太晚了
      -- (dapui 剛好還沒把自己的 before.attach/before.launch listener 掛上去)。
      -- 遇到這狀況的話,把上面這段改掛在 dap.listeners.before.launch 試試看,
      -- 兩種時機點哪個穩定,實測後留一個就好。
    end,
    keys = {
      { "<F5>",       function() require("dap").continue() end,                                      desc = "[Debug] Continue" },
      { "<F10>",      function() require("dap").step_over() end,                                     desc = "[Debug] Step over" },
      { "<F11>",      function() require("dap").step_into() end,                                     desc = "[Debug] Step into" },
      { "<F12>",      function() require("dap").step_out() end,                                      desc = "[Debug] Step out" },
      -- 修正:原本是 <leader>b,跟 <leader>bd/<leader>bD(刪除/wipeout buffer)
      -- 共用前綴,每次觸發都要多等 timeoutlen。改成 <leader>db,
      -- 順便跟你其他 dap 鍵(<leader>dr、<leader>dl)的命名慣例一致。
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                             desc = "[Debug] Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint() end,                                desc = "[Debug] Set breakpoint" },
      { "<leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: ")) end, desc = "[Debug] Log point" },
      { "<leader>dr", function() require("dap").repl.open() end,                                     desc = "[Debug] REPL" },
      { "<leader>dl", function() require("dap").run_last() end,                                      desc = "[Debug] Run last" },
    },
    cmd = { "DapContinue", "DapToggleBreakpoint" },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "User DapDebugStarted",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
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
      vim.keymap.set({ "n", "v" }, "<leader>dh", function() dapui.widgets.hover() end, { desc = "[Debug] Widgets hover" })
      vim.keymap.set({ "n", "v" }, "<leader>dp", function() dapui.widgets.preview() end, { desc = "[Debug] Widgets preview" })
      vim.keymap.set("n", "<leader>df", function() dapui.widgets.centered_float(dapui.widgets.frame) end,
        { desc = "[Debug] Widgets frames" })
      vim.keymap.set("n", "<leader>dS", function() dapui.widgets.centered_float(dapui.widgets.scopes) end,
        { desc = "[Debug] Widgets scopes" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "User DapDebugStarted",
    dependencies = {
      { "mason-org/mason.nvim" }, -- 記得也是 mason-org,不是 williamboman
      { "mfussenegger/nvim-dap" },
    },
    opts = {
      ensure_installed = {},
      handlers = {}
    }
  }
}
