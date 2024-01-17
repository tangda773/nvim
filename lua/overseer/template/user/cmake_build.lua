return {
  name = "cmake build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p:h") .. "/build"
    return {
      cmd = { "cmake" },
      args = { "--build", file },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "c", "cpp" },
  },
}
