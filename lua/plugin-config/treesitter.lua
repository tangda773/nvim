require'nvim-treesitter.configs'.setup {
  -- 安装 language parser
  -- :TSInstallInfo 命令查看支持的语言
  ensure_installed = {'cpp', 'lua', 'latex', 'markdown', 'markdown_inline', 'vim', 'cmake', 'rust', 'python', 'toml', 'json'},
  -- 啟用代碼高亮功能
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  -- rainbow parentheses
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  -- 啟用增量選擇
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },
  -- 啟用基於Treesitter的代碼格式化(=) . NOTE: This is an experimental feature.
  indent = {
    enable = true
  }
}
-- 開啟 Folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- 默認不要折疊
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.wo.foldlevel = 99
