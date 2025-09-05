return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  init = function ()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
              local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
              local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
              require("lsp_signature").on_attach({},bufnr)

              buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
              -- you can also put keymaps in here
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
            },
          },
        },
        -- DAP configuration
        dap = {
        },
      }
  end,
  lazy = false, -- This plugin is already lazy
}
