require("mason-tool-installer").setup({
  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {
    -- dap
    -- "cpptools",
    -- "codelldb",
    -- formatter
    "stylua",
    "clang-format",
    'gersemi',
    -- "yapf",
    "autopep8",
    -- linter
    "markdownlint",
    -- "vale",
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated.
  -- Default: false
  auto_update = false,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use `:MasonToolsUpdate` to install
  -- tools and check for updates.
  -- Default: true
  run_on_start = true,
})
