return {
  'saecki/crates.nvim',
  tag = 'stable',
  event = "bufreadpost *.toml",
  opts = {
    completion = {
      crates = {
        enabled = true,
      },
    },
    lsp = {
      enabled = true,
      actions = true,
      completion = true,
      hover = true,
    }
  },
}
