return {
  root_dir = function(fname)
    return vim.fs.root(fname, {
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.json",
      "package.json",
      ".git",
    })
  end,

  settings = {
    -- 官方建議的設定，讓 ESLint 只對打開的檔案工作
    workingDirectory = { mode = "auto" },
  },

  on_attach = function(client, bufnr)
    -- eslint 通常只負責 diagnostics + codeAction + format
    -- 你可以選擇保留 format-on-save 或改成手動
    -- 例如用 conform.nvim 叫 eslint_d:
    client.server_capabilities.documentFormattingProvider = false
  end,
}
