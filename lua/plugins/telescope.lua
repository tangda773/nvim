return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    cmd = "Telescope",
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  }
}
