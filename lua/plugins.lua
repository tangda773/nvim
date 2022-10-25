-- This file can be loaded by calling `lua require('plugins')`
-- from your init.vim

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Colortheme 主題
	use("folke/tokyonight.nvim")
	use("Abstract-IDE/Abstract-cs")
	use("rebelot/kanagawa.nvim")
	-- 狀態欄插件
	use({
		"nvim-lualine/lualine.nvim",
		"kyazdani42/nvim-web-devicons",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- 檔案管理插件
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})

	-- tab頁插件
	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })

	-- 語法高亮插件
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	use("p00f/nvim-ts-rainbow")

	-- 模糊搜詢插件
	use({
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		-- vim.ui.select to telescope
		"nvim-telescope/telescope-ui-select.nvim",
	})
	-- fzf 搜尋加強
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	-- LSP Client插件
	use({
		"williamboman/mason.nvim", -- Packager Manager for Lsp Servers, DAP Servers, linters, and formatters
		"williamboman/mason-lspconfig.nvim", -- Server Lsp Installer
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- Install or updated third-party tool
		"neovim/nvim-lspconfig", -- Collection of configurations for the built-in
		-- LSP client
	})

	-- 語法自動補全相關插件
	-- nvim-cmp
	use("hrsh7th/cmp-nvim-lsp") -- { name = nvim_lsp }
	use("hrsh7th/cmp-buffer") -- { name = 'buffer' },
	use("hrsh7th/cmp-path") -- { name = 'path' }
	use("hrsh7th/cmp-cmdline") -- { name = 'cmdline' }
  use("hrsh7th/cmp-nvim-lua")
  use("lukas-reineke/cmp-under-comparator")
  use("amarakon/nvim-cmp-lua-latex-symbols")
	use("hrsh7th/nvim-cmp")

	-- For luasnip users.
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")
	-- lspkind
	use("onsails/lspkind-nvim")

	-- LSP UI 美化
	use("tami5/lspsaga.nvim")

	-- LSP Symbols Tree
	-- use("simrat39/symbols-outline.nvim")

	-- lua 語法補全增強
	use("folke/neodev.nvim")

	-- 游標快速移動插件
	use({
		"phaazon/hop.nvim",
		branch = "v1", -- optional but strongly recommended
	})

	-- Session 管理插件
	use("Shatur/neovim-session-manager")

	-- LaTeX/Markdown Previewer
	use("frabjous/knap")

	-- Markdown Rendere in CLI
	-- use({ "ellisonleao/glow.nvim" })

	-- notification manager
	use("rcarriga/nvim-notify")

	use({
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
	})

	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- help you learn keymap
	use({
		"folke/which-key.nvim",
	})

	-- auto highlight other used current world
	use("RRethy/vim-illuminate")

	-- funciton signature
	use({
		"ray-x/lsp_signature.nvim",
	})

	-- debugger
	use("mfussenegger/nvim-dap")
	-- debugger UI
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	-- debugger installer
	-- use 'Pocco81/DAPInstall.nvim'

	-- Comment plugin
	use("numToStr/Comment.nvim")

	-- fixed bufdelete
	use("famiu/bufdelete.nvim")

	-- Code Runner
	-- use({ "michaelb/sniprun", run = "bash ./install.sh" })

	-- 顯示空格
	use("lukas-reineke/indent-blankline.nvim")

	-- Auto Save File
	-- use({ "Pocco81/auto-save.nvim", branch = "dev" })

	-- Lsp Linter
	-- use("mfussenegger/nvim-lint")

	-- Lsp formatter
	-- use({ "mhartington/formatter.nvim" })

	-- Lsp Linter & formatter
	use("jose-elias-alvarez/null-ls.nvim")

	-- For Rust Language
	-- use("simrat39/rust-tools.nvim")
	use({
		"saecki/crates.nvim",
		tag = "v0.2.1",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- For tmux
	-- use("aserowy/tmux.nvim")

	-- record coding history
	use("wakatime/vim-wakatime")

	-- Git
	-- use("kdheepak/lazygit.nvim")
	use("lewis6991/gitsigns.nvim")

  -- Project Management
	use("ahmedkhalf/project.nvim")

  -- Code Runner
	use("jedrzejboczar/toggletasks.nvim")

  -- Terminal
	use{"akinsho/toggleterm.nvim", tag='*'}

  -- TODO Plugin
  use { "folke/todo-comments.nvim",requires = "nvim-lua/plenary.nvim"}

  -- QuickFix Improve
  use {"kevinhwang91/nvim-bqf"}

  -- Surrounded Selection
  use {"kylechui/nvim-surround"}

  -- autopair plugin
  use {"windwp/nvim-autopairs"}
end)
