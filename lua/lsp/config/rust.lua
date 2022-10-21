local opts = {
	on_attach = function(client, bufnr)
		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		require("keybindings").mapLSP(buf_set_keymap)
		require("nvim-navic").attach(client, bufnr)
		require("illuminate").on_attach(client)
		require("lsp_signature").on_attach(client, bufnr)
	end,
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
}

-- 使用 cmp_nvim_lsp 代替内置 omnifunc，獲得更强的補全體驗
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
-- opts.capabilities = capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
opts.capabilities = capabilities

return {
	on_setup = function(server)
		server.setup(opts)
	end,
}
