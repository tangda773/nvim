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
      { "<F5>",       function() require("dap").continue() end,                                      desc = "Dap: continue" },
      { "<F10>",      function() require("dap").step_over() end,                                     desc = "Dap: step over" },
      { "<F11>",      function() require("dap").step_into() end,                                     desc = "Dap: step into" },
      { "<F12>",      function() require("dap").step_out() end,                                      desc = "Dap: step out" },
      -- 修正:原本是 <leader>b,跟 <leader>bd/<leader>bD(刪除/wipeout buffer)
      -- 共用前綴,每次觸發都要多等 timeoutlen。改成 <leader>db,
      -- 順便跟你其他 dap 鍵(<leader>dr、<leader>dl)的命名慣例一致。
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                             desc = "Dap: toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint() end,                                desc = "Dap: set breakpoint" },
      { "<leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: ")) end, desc = "[DAP] Log Point" },
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
      -- 移除:folke/lazydev.nvim 的 opts.library 擴充改集中寫在
      -- plugins/lazydev.lua 本體,不要在每個想要型別提示的插件檔案裡
      -- 各自宣告一份——zpack 不會像 lazy.nvim 那樣把它們合併起來,
      -- 只有 zpack 先 import 到的那份 opts 算數,其他都會被丟掉。
      -- 記得去 plugins/lazydev.lua 補上 "nvim-dap-ui" 這個項目。
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
      -- 修正:原本 <leader>ds 跟 plugins/fzf-lua.lua 的 lsp_document_symbols 撞鍵。
      -- 改成 <leader>dS(跟 dap 系列大寫慣例一致,<leader>dB 也是這樣處理的)。
      vim.keymap.set("n", "<leader>dS", function() dapui.widgets.centered_float(dapui.widgets.scopes) end,
        { desc = "Dap Widgets Scopes" })
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
