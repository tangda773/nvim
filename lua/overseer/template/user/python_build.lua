
-- For Flake8 first
local err_string = "%E%f:%l:\\ could\\ not\\ compile,"
err_string = err_string .. "%-Z%p^,"
err_string = err_string .. "%A%f:%l:%c:\\ %t%n\\ %m,"
err_string = err_string .. "%A%f:%l:\\ %t%n\\ %m,"

-- Python errors are multi-lined. They often start with 'Traceback', so
-- we want to capture that (with +G) and show it in the quickfix window
-- because it explains the order of error messages.
err_string = err_string .. "%+GTraceback%.%#,"

-- The error message itself starts with a line with 'File' in it. There
-- are a couple of variations, and we need to process a line beginning
-- with whitespace followed by File, the filename in "", a line number,
-- and optional further text. %E here indicates the start of a multi-line
-- error message. The %\C at the end means that a case-sensitive search is
-- required.
--
err_string = err_string .. "%E\\ \\ File\\ \"%f\"\\,\\ line\\ %l\\,%m%\\C,"
err_string = err_string .. "%E\\ \\ File\\ \"%f\"\\,\\ line\\%l%\\C,"

-- The possible continutation lines are idenitifed to Vim by %C. We deal
-- with these in order of most to least specific to ensure a proper
-- match. A pointer (^) identifies the column in which the error occurs
-- (but will not be entirely accurate due to indention of Python code).
--
err_string = err_string .. "%C%p^,"

-- Any text, indented by more than two spaces contain useful information.
-- We want this to appear in the quickfix window, hence %+.
--
err_string = err_string .. "%+C\\ \\ \\ \\ %.%#,"
err_string = err_string .. "%+C\\ \\ %.%#,"

-- The last line (%Z) does not begin with any whitespace. We use a zero
-- width lookahead (\&) to check this. The line contains the error
-- message itself (%m)
--
err_string = err_string .. "%Z%\\S%\\&%m,"

-- We can ignore any other lines (%-G)
--
err_string = err_string .. "%-G%.%#"

return {
  name = "Run Python Script",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "python3" },
      args = { file },
      components = { { "on_output_quickfix", open_on_match = true, errorformat = err_string }, "default" },
    }
  end,
  condition = {
    filetype = { "python" },
  },
}
