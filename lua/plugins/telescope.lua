return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    cmd = "Telescope",
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  }
}
