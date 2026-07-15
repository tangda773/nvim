return {
  -- 讓 tsserver 用專案的 tsconfig / jsconfig 當 root
  root_dir = function(fname)
    return vim.fs.root(fname, {
      "tsconfig.json",
      "jsconfig.json",
      "package.json",
      ".git",
    })
  end,

  -- 預設 filetypes 通常已經 OK，但明確寫也可以
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",    -- 如果你有 SFC
    "svelte", -- 若會用 Svelte
  },

  -- 這裡不動 capabilities，靠你共用的 config("*")
  -- 如果你要讓格式化交給 Prettier，可以在 on_attach 裡關掉
  on_attach = function(client, bufnr)
    -- 只用 eslint/prettier 格式化
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    -- 其它共用 keymap 可以用你 global 的 on_attach
  end,

  settings = {
    -- 這裡通常不用特別改，除非你有特殊 tsserver 設定
  },
}
