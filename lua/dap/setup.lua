local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local adapters = {
  python = require('dap.config.debugpy'),
  cpp = require('dap.config.cpptools'),
  c = require('dap.config.cpptools'),
  -- rust = require('dap.config.cpptools'),
}


for name, config in pairs(adapters) do
  if config ~= nil and type(config) == "table" then
    dap.configurations[name]  =  config
  end
end

