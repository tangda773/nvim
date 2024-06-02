local err_format = "%E%f:%l:%c: %trror: %m,%-Z%p^,%+C%.%#, %W%f:%l:%c: %tarning: %m,%-Z%p^,%+C%.%#"
return {
  name = "g++ build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "g++" },
      args = { file, "-o", vim.fn.expand("%:r") },
      components = { { "on_output_quickfix", open_on_match = true, errorformat = err_format }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
