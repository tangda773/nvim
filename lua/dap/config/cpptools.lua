local dap = require("dap")
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
}
return {
  {
    name = "Launch cpp file",
    type = "cppdbg",
    request = "launch",
    MIMode = "gdb",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.expand("%:p:h") .. "/build/" .. vim.fn.expand("%:p:h:t"))
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
  },
  {
    name = "Launch rust file",
    type = "cppdbg",
    request = "launch",
    MIMode = "gdb",
    miDebuggerPath = "/usr/bin/lldb",
    program = function()
      return vim.fn.input(
        "Path to executable: ",
        vim.fn.expand("%:p:h:h") .. "/target/debug/" .. vim.fn.expand("%:p:h:h:t:h")
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
    miDebuggerPath = "/usr/bin/lldb",
    cwd = "${workspaceFolder}",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.expand("%:p:h") .. "/build/" .. vim.fn.expand("%:p:h:t"))
    end,
  },
}
