require("mini.move").setup(
-- No need to copy this inside `setup()`. Will be used automatically.
{
  -- Module mappings. Use `''` (empty string) to disable one.

  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = '<c-h>',
    right = '<c-l>',
    down = '<c-j>',
    up = '<c-k>',

    -- Move current line in Normal mode
    line_left = '<c-h>',
    line_right = '<c-l>',
    line_down = '<c-j>',
    line_up = '<c-k>',
  },
  -- Options which control moving behavior
  options = {
    -- Automatically reindent selection during linewise vertical move
    reindent_linewise = true,
  },
})
