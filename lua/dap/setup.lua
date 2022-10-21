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
  cpp = require('dap.config.codelldb')
  -- cpp = require('dap.config.cpptools')
}


for name, config in pairs(adapters) do
  if config ~= nil and type(config) == "table" then
    dap.configurations[name]  =  config
  end
end

