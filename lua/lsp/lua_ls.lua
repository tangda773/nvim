---@type vim.lsp.Config
return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path == vim.fn.stdpath("config") then
        client.config.settings.Lua = vim.tbl_deep_extend("force",
          client.config.settings.Lua or {}, {
            runtime   = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          }
        )
      end
    end
  end,
  settings = {
    Lua = {
      telemetry = { enable = false },
    },
  },
}
