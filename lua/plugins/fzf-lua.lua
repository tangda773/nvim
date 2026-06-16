return{
  'ibhagwan/fzf-lua',
  -- optional for icon support
  -- dependencies = {"nvim-tree/nvim-web-devicons"}
  -- optional for icon support
  -- dependencies = {"nvim-mini/mini.icons"}
  opts = { },
  config = function(_, opts)
    vim.keymap.set('n','<leader><leader>',':FzfLua global<CR>',{desc='FzfLua global'})
    vim.keymap.set('n','<leader>sg',':FzfLua grep_curbuf<CR>',{desc='FzfLua grep_curbuf'})
    vim.keymap.set('n','<leader>sl',':FzfLua live_grep_curbuf<CR>',{desc='FzfLua live_grep_curbuf'})
    require("fzf-lua").setup(opts)
  end,
  cmd = "FzfLua",
}
