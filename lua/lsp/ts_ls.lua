local function ts_supports_lsp(bin)
  if vim.fn.executable(bin) ~= 1 then return false end
  local out = vim.system({ bin, "--version" }, { text = true }):wait()
  local version = vim.version.parse(out.stdout or "")
  return out.code == 0 and version ~= nil and version.major >= 7
end

---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
    if not root then return end

    -- 這個專案的本地 tsc 已支援 --lsp（TS7+），讓 `tsc` server 接手，ts_ls 不啟動
    local local_tsc = vim.fs.joinpath(root, "node_modules/.bin/tsc")
    if ts_supports_lsp(local_tsc) then
      return
    end

    on_dir(root)
  end,

  filetypes = {
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "vue", "svelte",
  },

  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,

  settings = {},
}
