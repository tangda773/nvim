-- This file can be loaded by calling `lua require('plugins')`
-- from your init.vim

return require("packer").startup(function()
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- speedup startup time
  use("lewis6991/impatient.nvim")

  -- Colortheme 主題
  use("folke/tokyonight.nvim")
  use("Abstract-IDE/Abstract-cs")
  use("rebelot/kanagawa.nvim")

  -- For terminal Icon
  use("nvim-tree/nvim-web-devicons")

  -- 狀態欄插件
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
  })

  -- 檔案管理插件
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icon
    },
    tag = "nightly", -- optional, updated every week. (see issue #1193)
  })

  -- tab頁插件
  use({ "akinsho/bufferline.nvim", requires = "nvim-tree/nvim-web-devicons" })

  -- 語法高亮插件
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  })
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })
  use({ "nvim-treesitter/nvim-treesitter-context" })
  -- use({ "nvim-treesitter/playground" })
  use("p00f/nvim-ts-rainbow")
  -- 模糊搜詢插件
  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    "nvim-telescope/telescope-live-grep-args.nvim",
  })
  -- fzf 搜尋加強
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  })
  -- luasnip view by telescope
  use({
    "benfowler/telescope-luasnip.nvim",
  })

  -- LaTeX build engine(with texlab)
  use({
    "jakewvincent/texmagic.nvim",
    ft = { "tex" },
    config = function()
      require("./plugin-config/texmagic")
    end,
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
  use({ "amarakon/nvim-cmp-lua-latex-symbols", ft = "tex" })
  use("hrsh7th/nvim-cmp")

  -- For luasnip users.
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets")
  -- lspkind
  use("onsails/lspkind-nvim")

  -- LSP UI 美化
  use({ "glepnir/lspsaga.nvim", branch = "main" })

  -- lua 語法補全增強
  use({
    "folke/neodev.nvim",
    ft = { "lua" },
    config = function()
      require("./plugin-config/neodev")
    end,
  })

  -- 游標快速移動插件
  use({
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
  })

  -- Session 管理插件
  use({
    "rmagatti/auto-session",
    -- auto-sessioon with telescope
    "rmagatti/session-lens",
  })
  -- notification manager
  use("rcarriga/nvim-notify")

  use({
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
  })

  -- help you learn keymap
  use({
    "folke/which-key.nvim",
  })

  -- auto highlight other used current world
  use("RRethy/vim-illuminate")

  -- funciton signature
  -- use({
  --   "ray-x/lsp_signature.nvim",
  -- })

  -- debugger
  use({
    "mfussenegger/nvim-dap",
    ft = { "cpp", "rust", "python", "lua" },
  })

  --debugger UI
  use({
    "rcarriga/nvim-dap-ui",
    ft = { "cpp", "rust", "python", "lua" },
    config = function()
      require("./dap/setup")
    end,
  })
  -- debugger for neovim lua
  use({ "jbyuki/one-small-step-for-vimkind", ft = "lua" })

  -- Comment plugin
  use("numToStr/Comment.nvim")

  -- fixed bufdelete
  use("famiu/bufdelete.nvim")

  -- 顯示空格
  use("lukas-reineke/indent-blankline.nvim")

  -- Lsp Linter & formatter
  use("jose-elias-alvarez/null-ls.nvim")

  -- For Rust Language
  -- use("simrat39/rust-tools.nvim")
  --
  use({
    "saecki/crates.nvim",
    tag = "v0.2.1",
    requires = { "nvim-lua/plenary.nvim" },
    ft = { "rust", "toml" },
    config = function()
      require("./plugin-config/crates")
    end,
  })

  -- record coding history
  use("wakatime/vim-wakatime")

  -- Git
  use("lewis6991/gitsigns.nvim")

  -- -- Project Management
  use("gnikdroy/projections.nvim")

  -- Run Code like vscode.task
  use({
    "stevearc/overseer.nvim",
  })
  -- Code Tester
  use({
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- NOTE: This Plugin is not needed after https://github.com/neovim/neovim/pull/20198
      --
      -- "antoinemadec/FixCursorHold.nvim",
      --
      -- Need Adapter
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test", -- required by neotest-vim-test
    },
  })

  -- Terminal
  use({ "akinsho/toggleterm.nvim", tag = "*" })

  -- TODO Plugin
  use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })

  -- QuickFix Improve
  use({ "kevinhwang91/nvim-bqf" })

  -- Surrounded Selection
  use({ "kylechui/nvim-surround" })

  -- autopair plugin
  use({ "windwp/nvim-autopairs" })

  -- startup menu
  use({
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
  })

  -- make background transparent
  use("xiyaowong/nvim-transparent")

  -- draw ascii diagram
  use({
    "jbyuki/venn.nvim",
    ft = { "tex", "markdown" },
    config = function()
      require("./plugin-config/venn")
    end,
  })

  -- auto save files
  use("pocco81/auto-save.nvim")

  -- mark/buffer/tabpage/colorscheme switcher
  use("toppair/reach.nvim")

  -- improve ui for notify/cmdline/messages
  use({
    "folke/noice.nvim",
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  })
  -- Markdown Previewer
  use({
    "davidgranstrom/nvim-markdown-preview",
    ft = "markdown",
    config = function()
      require("./plugin-config/markdown-preview")
    end,
  })

  -- LaTeX Previewer
  use({
    "lervag/vimtex",
    ft = "tex",
    config = function()
      require("./plugin-config/vimtex")
    end,
  })
end)
