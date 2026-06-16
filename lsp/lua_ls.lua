-- lsp/lua_ls.lua
return {
  on_init = function(client)
    -- 只在 Neovim config 目錄時才注入 vim runtime
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json")
          or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return  -- 專案有自己的 luarc，不干涉
      end
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force",
      client.config.settings.Lua or {}, {
        runtime  = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
      }
    )
  end,
  settings = {
    Lua = {
      telemetry = { enable = false },
    },
  },
}
