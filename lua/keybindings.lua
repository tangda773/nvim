local pluginKeys = {}

local opt = {
	noremap = true,
	silent = true,
}

pluginKeys.mappings = {
	f = {
		"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
		"Find Next Char",
	},
	F = {
		"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
		"Find Previous Char",
	},
	["<F9>"] = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle Breakpoint" },
	["<F5>"] = { "<cmd>lua require'dap'.continue()<CR>", "Continue" },
	["<F11>"] = { "<cmd>lua require'dap'.step_into()<CR>", "Step Into" },
	["<F12>"] = { "<cmd>lua require'dap'.step_over()<CR>", "Step Over" },
	["<A-n>"] = { "<cmd>lua require'illuminate'.next_reference{wrap=true}<cr>", "Next Reference" },
	["<A-p>"] = {
		"<cmd>lua require'illuminate'.next_reference{reverse=true,wrap=true}<cr>",
		"Next Reference Reverse",
	},
	["<A-F5>"] = { "<cmd>lua require('knap').process_once()<cr> ", "Process Once" },
	["<A-F6>"] = { "<cmd>lua require('knap').close_viewer()<cr> ", "Close Viewer" },
	["<A-F7>"] = { "<cmd>lua require('knap').toggle_autopreviewing()<cr> ", "Toggle Autopreviewing" },
	["<A-F8>"] = { "<cmd>lua require('knap').forward_jump()<cr>", "Forward Jump" },
	["<C-p>"] = { ":Telescope find_files<cr>", "Telescope Find Files" },
	["<C-f>"] = { ":Telescope live_grep<cr>", "Telescope Live Grep" },
	["<CR>"] = "init_selection/node_incremental",
	["<BS>"] = "node_decremental",
	["<TAB>"] = "scope_incremental",
	["<leader>"] = {
		name = "+Trouble & Formatter & Crates",
		f = { ":Format<CR>", "Format File" },
		F = { ":FormatWrite<CR>", "Format & Save File" },
		["="] = { "Lsp Formatting" },
		x = {
			name = "+Trouble",
			x = { "<cmd>Trouble<cr>", "Trouble" },
			w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
			d = { "<cmd>Trouble document_diagnostics<cr>", "Document Diagnostics" },
			l = { "<cmd>Trouble loclist<cr>", "Trouble Loclist" },
			q = { "<cmd>Trouble quickfix<cr>", "Trouble Quickfix" },
			r = { "<cmd>Trouble lsp_references<cr>", "Trouble Lsp Reference" },
			a = { "Lsp Code Action" },
		},
		c = {
			name = "+Crates",
			v = { "<cmd> lua require('crates').show_versions_popup()<CR>", "Show Crates Version" },
			f = { "<cmd> lua require('crates').show_features_popup()<CR>", "Show Crates Feature" },
			d = { "<cmd> lua require('crates').show_dependencies_popup()<CR>", "Show Crates Dependencies" },
			t = { "<cmd> lua require('crates').toggle()<CR>", "Crates Toggle" },
			r = { "<cmd> lua require('crates').reload()<CR>", "Crates Reload" },
			u = { "<cmd> lua require('crates').update_crate()<CR>", "Update Crate" },
			a = { "<cmd> lua require('crates').update_all_crates()<CR>", "Update All Crates" },
			H = { "<cmd> lua require('crates').open_homepage<CR>", "Crates Open Homepage" },
			R = { "<cmd> lua require('crates').open_repository<CR>", "Crates Open Repository" },
			D = { "<cmd> lua require('crates').open_documentation<CR>", "Crates Open Documentation" },
			C = { "<cmd> lua require('crates').open_crates_io()<CR>", "Crates Open Crates IO" },
		},
    h = {
      name = "+Gitsigns",
      s = "Gitsigns Stage Hunk",
      r = "Gitsigns Reset Hunk",
      S = "Gitsigns Stage Buffer",
      u = "Gitsigns Undo Stage Buffer",
      R = "Gitsigns Reset Buffer",
      p = "Gitsigns Preview Hunk",
      b = "Gitsigns Blame Line",
      d = "Gitsigns Diff This",
      D = "Gitsigns Diff This(~)",
    },
    t = {
      name = "+Gitsigns",
      b = "Gitsigns Toggle Current Line Blame",
      d = "Gitsigns Toggle Deleted",
    },
    ["gg"] = {"<cmd>:LazyGit<CR>", "LazyGit"},
    },
	g = {
		name = "+LSP Function",
		o = { "Show Line Diagnostics" },
		D = { "Show Declaration" },
		d = { "Show Definitions" },
		h = { "Show Hover Doc" },
		i = { "Show Implementation" },
		r = { "Show Finder" },
		n = { "Diagnostics Jump Next" },
		p = { "Diagnostics Jump Prev" },
		["cc"] = { "Comment Current Line" },
		["bc"] = { "Comment Current Block" },
	},
}
-- Telescope 列表中 插入模式快捷鍵
pluginKeys.telescopeList = {
	i = {
		["<C-n>"] = "move_selection_next",
		["<C-p>"] = "move_selection_previous",
	},
}

-- lsp 回調函數快捷鍵設置
pluginKeys.mapLSP = function(mapbuf)
	-- rename
	mapbuf("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opt)
	-- code action
	mapbuf("n", "<leader>xa", "<cmd>Lspsaga code_action<CR>", opt)
	-- go xx
	mapbuf("n", "gd", "<cmd>lua require'telescope.builtin'.lsp_definitions({ initial_mode = 'normal', })<CR>", opt)
	mapbuf("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opt)
	mapbuf("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
	mapbuf("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opt)
  mapbuf("n", "gr", ":Lspsaga lsp_finder<CR>", opt) -- diagnostic
	mapbuf("n", "go", "<cmd>Lspsaga show_line_diagnostics<CR>", opt)
	mapbuf("n", "gn", "<cmd>Lspsaga diagnostic_jump_next<cr>", opt)
	mapbuf("n", "gp", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opt)
	-- formatter
	mapbuf("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opt)
end



-- nvim-cmp 自動補全
local luasnip = require('luasnip')
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

pluginKeys.cmp = function(cmp)
	return {
		-- 確認
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({
			select = true,
			behavior = cmp.ConfirmBehavior.Replace,
		}),
		-- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}
end

return pluginKeys