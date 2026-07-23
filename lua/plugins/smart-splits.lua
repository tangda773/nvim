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
    { '<leader>wh', function() require('smart-splits').resize_left() end,       desc = "[Win] Resize left" },
    { '<leader>wj', function() require('smart-splits').resize_down() end,       desc = "[Win] Resize down" },
    { '<leader>wk', function() require('smart-splits').resize_up() end,         desc = "[Win] Resize up" },
    { '<leader>wl', function() require('smart-splits').resize_right() end,      desc = "[Win] Resize right" },
    { '<leader>wH', function() require('smart-splits').swap_buf_left() end,     desc = "[Win] Swap left" },
    { '<leader>wJ', function() require('smart-splits').swap_buf_down() end,     desc = "[Win] Swap down" },
    { '<leader>wK', function() require('smart-splits').swap_buf_up() end,       desc = "[Win] Swap up" },
    { '<leader>wL', function() require('smart-splits').swap_buf_right() end,    desc = "[Win] Swap right" },
  },
}
