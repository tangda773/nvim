local lazypath = vim.fn.stdpath("data") .. "\\lazy\\lazy.nvim"
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
  { "akinsho/bufferline.nvim",                    dependencies = "nvim-tree/nvim-web-devicons" },

  -- 語法高亮插件
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "nvim-treesitter/nvim-treesitter-context" },
  "p00f/nvim-ts-rainbow",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "benfowler/telescope-luasnip.nvim",
  },
  {
    "folke/neodev.nvim",
    ft = "lua",
    config = function()
      require("./plugin-config/neodev")
    end,
  },
  {
    "williamboman/mason.nvim",                 -- Packager Manager for Lsp Servers, DAP Servers, linters, and formatters
    "williamboman/mason-lspconfig.nvim",       -- Server Lsp Installer
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- Install or updated third-party tool
    "neovim/nvim-lspconfig",                   -- Collection of configurations for the built-in
    -- LSP client
  },
  "hrsh7th/cmp-nvim-lsp", -- { name = nvim_lsp }
  "hrsh7th/cmp-buffer",  -- { name = 'buffer' },
  "hrsh7th/cmp-path",    -- { name = 'path' }
  "hrsh7th/cmp-cmdline", -- { name = 'cmdline' }
  "hrsh7th/cmp-nvim-lua",
  "lukas-reineke/cmp-under-comparator",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "onsails/lspkind-nvim",

  -- LSP UI 美化
  { "glepnir/lspsaga.nvim",  branch = "main" },

  -- 游標快速移動插件
  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
  },
  {
    "rmagatti/auto-session",
    -- auto-sessioon with telescope
    "rmagatti/session-lens",
  },
  "rcarriga/nvim-notify",
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "folke/which-key.nvim",
  },
  "RRethy/vim-illuminate",
  { "mfussenegger/nvim-dap", ft = { "cpp", "rust", "python", "lua" } },
  {
    "rcarriga/nvim-dap-ui",
    -- dependencies = { "mfussenegger/nvim-dap" },
    ft = { "cpp", "rust", "python", "lua" },
    config = function()
      require("./dap/setup")
    end,
  },
  { "jbyuki/one-small-step-for-vimkind", ft = "lua" },
  "numToStr/Comment.nvim",
  "famiu/bufdelete.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  {
    "saecki/crates.nvim",
    version = "v0.2.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "rust", "toml" },
    config = function()
      require("./plugin-config/crates")
    end,
  },
  "wakatime/vim-wakatime",
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
  -- Run Code like vscode.task
  {
    "stevearc/overseer.nvim",
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
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
  },

  -- Terminal
  { "akinsho/toggleterm.nvim",  version = "*" },

  -- TODO Plugin
  { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" },
  { "kevinhwang91/nvim-bqf" },
  { "kylechui/nvim-surround" },
  { "windwp/nvim-autopairs" },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  "xiyaowong/nvim-transparent",
  "pocco81/auto-save.nvim",
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("./plugin-config/conflict")
    end,
  },

  -- mark/buffer/tabpage/colorscheme switcher
  "toppair/reach.nvim",
  {
    "folke/noice.nvim",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to  the notification view.
      --   If not available, we  `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  { "chipsenkbeil/distant.nvim", branch = "v0.2" },
  { "lervag/vimtex", ft = "tex" },
})
