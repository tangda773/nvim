local dap = require("dap")

local dapVirtualText = require("nvim-dap-virtual-text")
dapVirtualText.setup()

require("dap.ext.vscode").json_decode = require("overseer.json").decode

-- local dapui = require('dapui')
--
-- dapui.setup()
--
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end

local adapters = {
  python = require("dap.config.debugpy"),
  -- cpp = require('dap.config.cpptools'),
  -- c = require('dap.config.cpptools'),
  -- rust = require('dap.config.cpptools'),
  -- cpp = require("dap.config.codelldb"),
  -- c = require("dap.config.codelldb"),
  -- rust = require('dap.config.codelldb'),
     cpp = require("dap.config.lldb-vscode"),
     c = require("dap.config.lldb-vscode"),
}

for name, config in pairs(adapters) do
  if config ~= nil and type(config) == "table" then
    dap.configurations[name] = config
  end
end
