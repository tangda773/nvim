local dap = require('dap')
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
    args = {"--port", "${port}"},

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

return {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.expand('%:p:h') .. '/build/'.. vim.fn.expand('%:p:h:t') )
    end,
    cwd = function()
      return vim.fn.expand('%:p:h')
    end,
    stopOnEntry = true,
  },
}
