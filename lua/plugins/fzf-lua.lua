return{
  'ibhagwan/fzf-lua',
  -- optional for icon support
  -- dependencies = {"nvim-tree/nvim-web-devicons"}
  -- optional for icon support
  -- dependencies = {"nvim-mini/mini.icons"}
  opts = {},
  keys = {
    {"<leader><leader>", ":FzfLua global<CR>", desc="FzfLua global"},
    {"<leader>sg", ":FzfLua grep_curbuf<CR>", desc="FzfLua grep_curbuf"},
    {"<leader>sl", ":FzfLua live_grep_curbuf<CR>", desc="FzfLua lgrep_curbuf"},
  },
  lazy = false,
}
