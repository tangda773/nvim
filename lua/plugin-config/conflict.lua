require('git-conflict').setup()

-- Detected git conflicts
vim.api.nvim_create_autocmd('User', {
  pattern = 'GitConflictDetected',
  callback = function()
    vim.notify('Conflict detected in '..vim.fn.expand('<afile>'))
  end
})
