require('lint').linters_by_ft = {
  markdown = {'markdownlint'},
  -- markdown = {'vale'},
}
local lint_progress = function()
  local linters = require("lint").get_running()
  if #linters == 0 then
      return nil
  end
  return table.concat(linters, ", ")
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    if lint_progress() ~= nil then
      require("lint").try_lint()
    end

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("vale")
  end,
})
