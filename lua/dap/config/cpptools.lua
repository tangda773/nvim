local dap = require("dap")
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = "OpenDebugAD7.cmd",
  options = {
    detached = false,
  },
}
return {
  {
    name = "Launch cpp file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input(
        "Path to executable: ",
        vim.fn.expand("%:p:h") .. "\\build\\" .. vim.fn.expand("%:p:h:t")
      )
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
  },
  {
    name = "Launch rust file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input(
        "Path to executable: ",
        vim.fn.expand("%:p:h:h") .. "\\target\\debug\\" .. vim.fn.expand("%:p:h:h:t:h")
      )
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
  },
  {
    name = "Attach to gdbserver :1234",
    type = "cppdbg",
    request = "launch",
    MIMode = "gdb",
    miDebuggerServerAddress = "localhost:1234",
    miDebuggerPath = "gdb",
    cwd = "${workspaceFolder}",
    program = function()
      return vim.fn.input(
        "Path to executable: ",
        vim.fn.expand("%:p:h") .. "\\build\\" .. vim.fn.expand("%:p:h:t")
      )
    end,
  },
}
