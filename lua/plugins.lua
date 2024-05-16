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
  -- 主題
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
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy", -- Vim 完成啟動後加載
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- 非必須，但建議使用
      "MunifTanjim/nui.nvim",
      {
        -- 僅當你想使用帶有 "_with_window_picker" 後綴的命令時需要
        "s1n7ax/nvim-window-picker",
        version = "v1.*",
        config = function()
          require("plugin-config.window-picker")
        end,
      },
    },
    cmd = "Neotree", -- 使用 `:Neotree` 命令時加載
  },
  -- 標籤頁插件
  { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons", event = "VeryLazy" }, -- Vim 完成啟動後加載

  -- 語法高亮插件
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost", -- 讀取緩衝區後加載
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      -- "nvim-treesitter/playground",
      "p00f/nvim-ts-rainbow",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
  -- 模糊查詢插件
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope", -- 使用 `:Telescope` 命令時加載
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "benfowler/telescope-luasnip.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
  },

  -- Lua 語法補全增強
  {
    "folke/neodev.nvim",
    ft = "lua", -- 打開 Lua 文件時加載
    config = function()
      require("./plugin-config/neodev")
    end,
  },

  -- LSP 客戶端插件
  {
    "williamboman/mason.nvim",                 -- Lsp 伺服器、DAP 伺服器、檢查器和格式化工具的包管理器
    "williamboman/mason-lspconfig.nvim",       -- 伺服器 Lsp 安裝器
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- 安裝或更新第三方工具
    "neovim/nvim-lspconfig",                   -- 內置 LSP 客戶端的配置集合
    event = "BufReadPre",                      -- 讀取緩衝區之前加載
  },

  -- 語法自動補全相關插件
  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- 進入插入模式時加載
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- { name = nvim_lsp }
      "hrsh7th/cmp-buffer", -- { name = 'buffer' },
      "hrsh7th/cmp-path",  -- { name = 'path' }
      "hrsh7th/cmp-cmdline", -- { name = 'cmdline' }
      "hrsh7th/cmp-nvim-lua",
      "lukas-reineke/cmp-under-comparator",
      "amarakon/nvim-cmp-lua-latex-symbols",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  -- lspkind
  { "onsails/lspkind-nvim",    event = "InsertEnter" }, -- 進入插入模式時加載

  -- LSP UI 美化
  { "glepnir/lspsaga.nvim",    branch = "main",                              event = "LspAttach" }, -- LSP 附加時加載

  -- 游標快速移動插件
  { "phaazon/hop.nvim",        branch = "v2",                                event = "VeryLazy" }, -- Vim 完成啟動後加載

  -- 會話管理插件
  {
    "Shatur/neovim-session-manager",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    cmd = "SessionManager", -- 使用 `:SessionManager` 命令時加載
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = "TroubleToggle", -- 使用 `:TroubleToggle` 命令時加載
  },

  -- 幫助你學習快捷鍵
  {
    "folke/which-key.nvim",
    event = "VeryLazy", -- Vim 完成啟動後加載
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },
  -- 自動高亮其他使用的當前單詞
  { "RRethy/vim-illuminate", event = "BufReadPost" }, -- 讀取緩衝區後加載

  -- 調試器
  { "mfussenegger/nvim-dap", event = "BufReadPost" }, -- 讀取緩衝區後加載
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    },
    config = function()
      require("./dap/setup")
    end,
    event = "BufReadPost",                            -- 讀取緩衝區後加載
  },
  { "jbyuki/one-small-step-for-vimkind", ft = "lua" }, -- 打開 Lua 文件時加載

  -- 註釋插件
  { "numToStr/Comment.nvim",             event = "BufReadPost" }, -- 讀取緩衝區後加載
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    cmd = "Neogen", -- 使用 `:Neogen` 命令時加載
  },
  -- 緩衝區刪除修復
  { "famiu/bufdelete.nvim",                event = "VeryLazy" }, -- Vim 完成啟動後加載

  -- 顯示空白字符
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPost" }, -- 讀取緩衝區後加載

  -- LSP 檢查器和格式化工具
  { "jose-elias-alvarez/null-ls.nvim",     event = "BufReadPost" }, -- 讀取緩衝區後加載

  -- 記錄編碼歷史
  { "wakatime/vim-wakatime",               event = "VeryLazy" }, -- Vim 完成啟動後加載

  -- Git 插件
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("./plugin-config/gitsigns")
    end,
    event = { "BufReadPost", "BufNewFile" }, -- 讀取緩衝區後或新建文件時加載
  },

  -- Vim Git 命令
  { "tpope/vim-fugitive", cmd = "Git" }, -- 使用 `:Git` 命令時加載
  { "rbong/vim-flog",     cmd = "Flog" }, -- 使用 `:Flog` 命令時加載
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("./plugin-config/conflict")
    end,
    event = "BufReadPost", -- 讀取緩衝區後加載
  },

  -- 代碼運行器
  { "michaelb/sniprun",       build = "bash ./install.sh", cmd = "SnipRun" }, -- 使用 `:SnipRun` 命令時加載

  -- 像 VSCode 任務一樣運行代碼
  { "stevearc/overseer.nvim", cmd = "OverseerRun" }, -- 使用 `:OverseerRun` 命令時加載

  -- 代碼測試
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
    },
    event = "BufReadPost", -- 讀取緩衝區後加載
  },

  -- 終端
  { "akinsho/toggleterm.nvim",  version = "*",                          cmd = "ToggleTerm" }, -- 使用 `:ToggleTerm` 命令時加載

  -- TODO 插件
  { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim", event = "BufReadPost" }, -- 讀取緩衝區後加載

  -- QuickFix 改善
  { "kevinhwang91/nvim-bqf",    ft = "qf" }, -- 打開 Quickfix 文件類型時加載

  -- 環繞選擇插件
  { "kylechui/nvim-surround",   event = "VeryLazy" }, -- Vim 完成啟動後加載

  -- 自動補全括號插件
  { "windwp/nvim-autopairs",    event = "InsertEnter" }, -- 進入插入模式時加載

  -- 啟動菜單
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter", -- Vim 啟動並加載配置後觸發
  },
  -- 自動保存文件
  { "pocco81/auto-save.nvim", event = "VeryLazy" }, -- Vim 完成啟動後加載

  -- 改善通知/UI 的插件
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    event = "VeryLazy", -- Vim 完成啟動後加載
  },
  {
    "saecki/crates.nvim",
    tag = "v0.3.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugin-config/crates")
    end,
    ft = { "toml" }, -- 打開 toml 文件時加載
  },
  {
    "lervag/vimtex",
    ft = { "tex" }, -- 打開 tex 文件時加載
    config = function()
      require("plugin-config/vimtex")
    end,
  },
  {
    "ray-x/web-tools.nvim",
    config = function()
      require("plugin-config/web-tools")
    end,
    event = "VeryLazy",                                    -- Vim 完成啟動後加載
  },
  { "ellisonleao/glow.nvim",  config = true,     cmd = "Glow" }, -- 使用 `:Glow` 命令時加載

  {
    "Civitasv/cmake-tools.nvim",
    config = function()
      require("plugin-config/cmake-tools")
    end,
    cmd = "CMakeGenerate", -- 使用 `:CMakeGenerate` 命令時加載
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    cmd = "Leet",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- telescope 需要
      "MunifTanjim/nui.nvim",

      -- 可選
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lang = "rust",
      plugins = { non_standalone = true },
    },
  },
  {
    "xiyaowong/transparent.nvim",
    event = "VeryLazy", -- Vim 完成啟動後加載
  },
  {
    "sontungexpt/url-open",
    cmd = "URLOpenUnderCursor", -- "使用 `:URLOpenUnderCursor`命令時加載"
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({})
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    event = "VeryLazy", -- Vim 完成啟動後加載
  },
})
