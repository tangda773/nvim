local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- LocalLeader triggers（orgmode buffer 的 <localleader>o* 系列）
    { mode = 'n', keys = '<LocalLeader>' },
    { mode = 'x', keys = '<LocalLeader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },

  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),

    -- 前綴群組標題（mini.clue 提示列第一行顯示 desc）
    { mode = 'n', keys = '<leader>f', desc = '+find' },
    { mode = 'n', keys = '<leader>g', desc = '+git' },
    { mode = 'n', keys = '<leader>l', desc = '+lsp' },
    { mode = 'n', keys = '<leader>lw', desc = '+lsp-workspace' },
    { mode = 'n', keys = '<leader>x', desc = '+diagnostics' },
    { mode = 'n', keys = '<leader>d', desc = '+debug' },
    { mode = 'n', keys = '<leader>t', desc = '+test' },
    { mode = 'n', keys = '<leader>T', desc = '+terminal' },
    { mode = 'n', keys = '<leader>b', desc = '+buffer' },
    { mode = 'n', keys = '<leader>w', desc = '+window' },
    { mode = 'n', keys = '<leader>a', desc = '+ai' },
    { mode = 'n', keys = '<leader>o', desc = '+org' },
    { mode = 'n', keys = '<leader>r', desc = '+remote' },
  },
})
