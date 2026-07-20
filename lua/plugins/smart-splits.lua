return {
  'mrjones2014/smart-splits.nvim',
  opts = {

  },
  keys = {
    { '<C-h>',      function() require('smart-splits').move_cursor_left() end,  desc = "Split: move left" },
    { '<C-j>',      function() require('smart-splits').move_cursor_down() end,  desc = "Split: move down" },
    { '<C-k>',      function() require('smart-splits').move_cursor_up() end,    desc = "Split: move up" },
    { '<C-l>',      function() require('smart-splits').move_cursor_right() end, desc = "Split: move right" },
    -- { '<C-\\>',     function() require('smart-splits').move_cursor_previous() end, desc = "Split: move previous" },
    { '<leader>wh', function() require('smart-splits').resize_left() end,       desc = "Split: resize left" },
    { '<leader>wj', function() require('smart-splits').resize_down() end,       desc = "Split: resize down" },
    { '<leader>wk', function() require('smart-splits').resize_up() end,         desc = "Split: resize up" },
    { '<leader>wl', function() require('smart-splits').resize_right() end,      desc = "Split: resize right" },
    { '<leader>sh', function() require('smart-splits').swap_buf_left() end,     desc = "Split: swap left" },
    { '<leader>sj', function() require('smart-splits').swap_buf_down() end,     desc = "Split: swap down" },
    { '<leader>sk', function() require('smart-splits').swap_buf_up() end,       desc = "Split: swap up" },
    { '<leader>sl', function() require('smart-splits').swap_buf_right() end,    desc = "Split: swap right" },
  },
}
