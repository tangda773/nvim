return {
  {
    'mrjones2014/smart-splits.nvim',
    opts = {

    },
    config = function(_, opts)
      require('smart-splits').setup(opts)
      -- recommended mappings
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left, { desc = "Smart-Splits resize_left" })
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down, { desc = "Smart-Splits resize_down" })
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up, { desc = "Smart-Splits resize_up" })
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right, { desc = "Smart-Splits resize_right" })
      -- moving between splits
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = "Smart-Splits move_cursor_left" })
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = "Smart-Splits move_cursor_down" })
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = "Smart-Splits move_cursor_up" })
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = "Smart-Splits move_cursor_right" })
      vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous, {
        desc =
        "Smart-Splits move_cursor_previous"
      })
      -- swapping buffers between windows
      vim.keymap.set('n', '<leader>sh', require('smart-splits').swap_buf_left, { desc = "Smart-Splits swap_buft left" })
      vim.keymap.set('n', '<leader>sj', require('smart-splits').swap_buf_down, { desc = "Smart-Splits swap_buft down" })
      vim.keymap.set('n', '<leader>sk', require('smart-splits').swap_buf_up, { desc = "Smart-Splits swap_buft up" })
      vim.keymap.set('n', '<leader>sl', require('smart-splits').swap_buf_right, { desc = "Smart-Splits swap_buft right" })
    end
  }
  -- or use a specific version, or a range of versions using lazy.nvim's version API
  -- { 'mrjones2014/smart-splits.nvim', version = '>=1.0.0' }
  -- to use Kitty multiplexer support, run the post install hook
  -- { 'mrjones2014/smart-splits.nvim', build = './kitty/install-kittens.bash' }
}
