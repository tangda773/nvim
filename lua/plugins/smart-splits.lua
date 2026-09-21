return {
  'mrjones2014/smart-splits.nvim',
  opts = {

  },
  keys = {
    { '<C-h>',      function() require('smart-splits').move_cursor_left() end,  desc = "[Window] Move left" },
    { '<C-j>',      function() require('smart-splits').move_cursor_down() end,  desc = "[Window] Move down" },
    { '<C-k>',      function() require('smart-splits').move_cursor_up() end,    desc = "[Window] Move up" },
    { '<C-l>',      function() require('smart-splits').move_cursor_right() end, desc = "[Window] Move right" },
    -- { '<C-\\>',     function() require('smart-splits').move_cursor_previous() end, desc = "[Window] Move previous" },
    { '<leader>wh', function() require('smart-splits').resize_left() end,       desc = "[Window] Resize left" },
    { '<leader>wj', function() require('smart-splits').resize_down() end,       desc = "[Window] Resize down" },
    { '<leader>wk', function() require('smart-splits').resize_up() end,         desc = "[Window] Resize up" },
    { '<leader>wl', function() require('smart-splits').resize_right() end,      desc = "[Window] Resize right" },
    { '<leader>wH', function() require('smart-splits').swap_buf_left() end,     desc = "[Window] Swap left" },
    { '<leader>wJ', function() require('smart-splits').swap_buf_down() end,     desc = "[Window] Swap down" },
    { '<leader>wK', function() require('smart-splits').swap_buf_up() end,       desc = "[Window] Swap up" },
    { '<leader>wL', function() require('smart-splits').swap_buf_right() end,    desc = "[Window] Swap right" },
  },
}
