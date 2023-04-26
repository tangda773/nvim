local efm = "%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %t: %m"
return {
  name = "cmake build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = "./build"
    return {
      cmd = { "cmake" },
      args = { "--build", file },
      components = { { "on_output_quickfix", open = true, errorformat = efm }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
}
