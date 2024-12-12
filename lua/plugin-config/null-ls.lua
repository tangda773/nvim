local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    -- null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.autopep8,
    -- null_ls.builtins.formatting.clang_format,
    -- null_ls.builtins.code_actions.gitsigns,
    -- null_ls.builtins.diagnostics.chktex,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.formatting.gersemi
  },
})
