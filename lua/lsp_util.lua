local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

M.on_attach = function(client, bufnr)
  vim.api.nvim_set_option_value('omnifunc', "v:lua.vim.lsp.omnifunc", { buf = bufnr })

  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efintion")
  nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
  nmap("gf", vim.lsp.buf.format, "Lsp Format")
  nmap("gq", vim.diagnostic.setloclist, "Lsp Diagnostics Location List")
  nmap("K", vim.lsp.buf.hover, "Hover Documention")
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
end

M.servers = {
  clangd = {},
  lua_ls = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
          return
        end
      end

      client.config.settings.lua = vim.tbl_deep_extend("force", client.config.settings.Lua,
        {
          runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" },
          },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          }
        })
    end,
    settings = { Lua = {} },
  },

  -- rust_analyzer = {
  --   settings = {
  --     ['rust-analyzer'] = {
  --       diagnostics = {
  --         enable = false,
  --       }
  --     }
  --   }
  -- }
}

-- remote-ssh.nvim 專用
-- M.filetype_to_server = {}

M.setup_servers = function()
  for server_name, server_opts in pairs(M.servers) do
    vim.lsp.config(server_name, vim.tbl_deep_extend("force", {
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    }, server_opts))

    vim.lsp.enable(server_name)

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
    })
  end
end

return M
