-- CMake Parser
-- Call stack entries
local efm = " %#%f:%l %#(%m)"
-- Start of multi-line error
efm = efm .. ",%E CMake Error at %f:%l (%m):"
-- End of multi-line error
efm = efm .. ",%Z Call Stack (most recent call first):"
-- Continuation is message
efm = efm .. ",%C %m"
return {
  name = "cmake generate file",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = "./"
    return {
      cmd = { "cmake" },
      args = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON", file },
      components = { { "on_output_quickfix", open_on_match = true, errorformat = efm }, "default" },
    }
  end,
  condition = {
    filetype = { "cmake" },
  },
}
