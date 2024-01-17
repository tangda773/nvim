return {
  name = "cmake generate files",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p:h") .. "/build"
    return {
      cmd = { "cmake" },
      args = { file },
      components = {
        { "on_output_quickfix", open = true },
        {
          "dependencies",
          task_names = { "create build dir", { "shell", cmd = "mkdir build" } },
          sequential = true,
        },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "cmake" },
  },
}
