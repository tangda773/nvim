require("neogen").setup({
  enabled = true,
  languages = {
    lua = {
      template = {
        annotation_convention = "emmylua", -- for a full list of annotation_conventions, see supported-languages below,
        -- for more template configurations, see the language's configuration file in configurations/{lang}.lua
      },
    },
    cpp = {
      template = {
        annotation_convention = "doxygen",
      },
    },
    c = {
      template = {
        annotation_convention = "doxygen",
      },
    },
    sh = {
      template = {
        annotation_convention = "google_bash",
      },
    },
    python = {
      template = {
        annotation_convention = "google_docstrings",
      },
    },
    rust = {
      template = {
        annotation_convention = "rustdoc",
      },
    },
  },
  snippet_engine = "luasnip",
})
