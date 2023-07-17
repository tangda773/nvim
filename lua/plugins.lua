local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colortheme 主題
  "folke/tokyonight.nvim",
  "Abstract-IDE/Abstract-cs",
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme kanagawa]])
    end,
  },
  -- 狀態欄插件
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        version = "v1.*",
        config = function()
          require("plugin-config.window-picker")
        end,
      },
    },
  },
  -- tab頁插件
  { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },

  -- 語法高亮插件
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      --  "nvim-treesitter/playground" ,
      "p00f/nvim-ts-rainbow",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
  -- 模糊搜詢插件
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  -- fzf 搜尋加強
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  -- luasnip view by telescope
  {
    "benfowler/telescope-luasnip.nvim",
  },

  -- lua 語法補全增強
  {
    "folke/neodev.nvim",
    ft = "lua",
    config = function()
      require("./plugin-config/neodev")
    end,
  },

  -- LSP Client插件
  {
    "williamboman/mason.nvim",                 -- Packager Manager for Lsp Servers, DAP Servers, linters, and formatters
    "williamboman/mason-lspconfig.nvim",       -- Server Lsp Installer
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- Install or updated third-party tool
    "neovim/nvim-lspconfig",                   -- Collection of configurations for the built-in
  },

  -- 語法自動補全相關插件
  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    -- nvim-cmp source
    "hrsh7th/cmp-nvim-lsp", -- { name = nvim_lsp }
    "hrsh7th/cmp-buffer", -- { name = 'buffer' },
    "hrsh7th/cmp-path",   -- { name = 'path' }
    "hrsh7th/cmp-cmdline", -- { name = 'cmdline' }
    "hrsh7th/cmp-nvim-lua",
    "lukas-reineke/cmp-under-comparator",
    "amarakon/nvim-cmp-lua-latex-symbols",
    -- For luasnip users.
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  -- lspkind
  "onsails/lspkind-nvim",

  -- LSP UI 美化
  { "glepnir/lspsaga.nvim",    branch = "main" },

  -- 游標快速移動插件
  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
  },

  -- Session 管理插件
  {
    "Shatur/neovim-session-manager",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- pretty ui with vim.ui.select, vim.ui.input
      "stevearc/dressing.nvim",
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
  },

  -- help you learn keymap
  {
    "folke/which-key.nvim",
  },
  -- auto highlight other used current world
  { "RRethy/vim-illuminate" },

  -- debugger
  { "mfussenegger/nvim-dap", ft = { "cpp", "rust", "python", "lua" } },
  -- debugger UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "cpp", "rust", "python", "lua" },
    config = function()
      require("./dap/setup")
    end,
  },
  -- debugger for neovim lua
  { "jbyuki/one-small-step-for-vimkind", ft = "lua" },
  -- Comment plugin
  { "numToStr/Comment.nvim" },
  -- Comment
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
  },
  -- fixed bufdelete
  "famiu/bufdelete.nvim",

  -- 顯示空格
  "lukas-reineke/indent-blankline.nvim",

  -- Lsp Linter & formatter
  "jose-elias-alvarez/null-ls.nvim",

  -- record coding history
  "wakatime/vim-wakatime",

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("./plugin-config/gitsigns")
    end,
  },

  -- vim git command
  "tpope/vim-fugitive",
  "rbong/vim-flog",
  -- git resolve conflict
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("./plugin-config/conflict")
    end,
  },

  -- Code Runner
  { "michaelb/sniprun",         build = "bash ./install.sh" },

  -- Run Code like vscode.task
  {
    "stevearc/overseer.nvim",
  },
  -- Code Tester
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- NOTE: This Plugin is not needed after https://github.com/neovim/neovim/pull/20198
      -- "antoinemadec/FixCursorHold.nvim",
      -- Need Adapter
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test", -- required by neotest-vim-test
    },
  },

  -- Terminal
  { "akinsho/toggleterm.nvim",  version = "*" },

  -- TODO Plugin
  { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" },

  -- QuickFix Improve
  { "kevinhwang91/nvim-bqf" },

  -- Surrounded Selection
  { "kylechui/nvim-surround" },

  -- autopair plugin
  { "windwp/nvim-autopairs" },

  -- startup menu
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- auto save files
  "pocco81/auto-save.nvim",

  -- improve ui for notify/cmdline/messages
  {
    "folke/noice.nvim",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "saecki/crates.nvim",
    tag = "v0.3.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugin-config/crates")
    end,
    ft = { "toml" },
  },
  {
    "axieax/urlview.nvim",
    config = function()
      require("plugin-config/urlview")
    end,
  },
  {
    "lervag/vimtex",
    ft = { "markdown", "tex" },
    config = function()
      require("plugin-config/vimtex")
    end,
  },
})
