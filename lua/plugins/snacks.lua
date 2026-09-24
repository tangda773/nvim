return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy     = false,
  opts     = {
    -- ── 填補你目前的空缺 ──────────────────────
    input        = { enabled = true },                 -- vim.ui.input
    notifier     = { enabled = true, timeout = 3000 }, -- nvim-notify
    scratch      = { enabled = true },                 --  scratch.nvim
    words        = { enabled = true },                 -- 游標單字高亮
    profiler     = { enabled = true },
    -- 大檔案偵測 + 效能降級，取代原本的 faster.nvim
    bigfile      = {
      enabled = true,
      notify = true,
      size = 2 * 1024 * 1024, -- 2MiB；沿用 faster.nvim 原本 bigfile 的 `filesize = 2` 門檻
      line_length = 250,      -- 平均每行 bytes；沿用 faster.nvim longline 的 `avg_bytes_per_line = 250` 門檻
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd([[NoMatchParen]])
        end
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        vim.b.completion = false
        vim.b.minianimate_disable = true
        vim.b.minihipatterns_disable = true
        -- 沿用 faster.nvim 的 vimopts 行為：大檔案不寫 swapfile、不建立巨大 undo tree
        vim.opt_local.swapfile = false
        vim.opt_local.undolevels = -1
        vim.opt_local.undoreload = 0
        vim.opt_local.list = false
        vim.opt_local.spell = false
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },
    -- 啟動時盡快渲染首個檔案內容，取代原本的 faster.nvim
    quickfile    = { enabled = true },

    -- ── 其他全部關掉 ──────────────────────────
    animate      = { enabled = false }, -- mini.animate
    dashboard    = { enabled = false }, -- mini.starter
    explorer     = { enabled = false }, -- mini.files
    indent       = { enabled = false }, -- mini.indentscope
    picker       = { enabled = false }, -- fzf-lua
    scope        = { enabled = false }, -- mini.indentscope
    scroll       = { enabled = false }, -- mini.animate
    statuscolumn = { enabled = false }, -- statuscol.nvim
    terminal     = { enabled = true },  -- toggleterm
    lazygit      = { enabled = false }, -- neogit
    gitbrowse    = { enabled = false }, -- neogit
    zen          = { enabled = false },
    dim          = { enabled = false },
  },
  -- 在 keys 或 init 裡加：
  init     = function()
    -- LSP progress 整合
    vim.api.nvim_create_autocmd("LspProgress", {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value  = ev.data.params.value
        if not client or type(value) ~= "table" then return end

        local title   = value.title or ""
        local message = value.message or ""
        local pct     = value.percentage

        -- 完成時不顯示
        if value.kind == "end" then
          Snacks.notifier.hide("lsp_progress_" .. ev.data.client_id)
          return
        end

        local text = client.name
        if title ~= "" then
          text = text .. ": " .. title
        end
        if message ~= "" then
          text = text .. " " .. message
        end
        if pct then
          text = text .. " (" .. pct .. "%)"
        end

        Snacks.notify.info(text, {
          id      = "lsp_progress_" .. ev.data.client_id,
          title   = "LSP",
          timeout = false, -- 不自動消失，等 end event
        })
      end,
    })
  end,
  config   = function(_, opts)
    opts.image = {
      enabled = true,
      ---@param path string
      ---@param src string
      ---@return string?
      resolve = function(path, src)
        if require("obsidian.api").path_is_note(path) then
          return require("obsidian.api").resolve_image_path(src)
        end
      end,
    }
    require("snacks").setup(opts)
  end,
  keys     = {
    -- words 跳轉
    { "]]",         function() Snacks.words.jump(1) end,              desc = "Next word occurrence" },
    { "[[",         function() Snacks.words.jump(-1) end,             desc = "Prev word occurrence" },

    -- scratch
    { "<leader>.",  function() Snacks.scratch() end,                  desc = "Toggle scratch" },
    { "<leader>fs", function() Snacks.scratch.select() end,           desc = "[Find] Select scratch" },

    -- notifier 歷史
    { "<leader>fn", function() Snacks.notifier.show_history() end,    desc = "[Find] Notify history" },

    -- profiler
    { "<leader>pp", function() Snacks.toggle.profiler():toggle() end, desc = "[Profiler] Toggle", },
    { "<leader>ps", function() Snacks.profiler.scratch() end,         desc = "[Profiler] Scratch", },

    -- Terminal
    {
      "<C-t>",
      function()
        Snacks.terminal.toggle(nil, { cwd = vim.uv.cwd(), win = { position = "bottom", height = 0.25 } })
      end,
      mode = { "n", "t" },
      desc = "[Terminal] Bottom (數字前綴開多個，如 2<C-t>)"
    },
    {
      "<C-v>",
      function()
        Snacks.terminal.toggle(nil, { cwd = vim.uv.cwd(), win = { position = "right", width = 0.33 } })
      end,
      mode = { "n", "t" },
      desc = "[Terminal] Right (數字前綴開多個，如 2<C-v>)"
    },
    {
      "<C-g>",
      function()
        Snacks.terminal.toggle(nil, { cwd = vim.uv.cwd(), win = { position = "float", border = "rounded" } })
      end,
      mode = { "n", "t" },
      desc = "[Terminal] Float (數字前綴開多個，如 2<C-g>)"
    },
    {
      "<C-y>",
      function()
        vim.cmd("tabnew")
        Snacks.terminal.open(nil, { cwd = vim.uv.cwd(), win = { position = "current" } })
      end,
      mode = { "n", "t" },
      desc = "[Terminal] New tab (數字前綴開多個，如 2<C-y>)"
    },
  },
}
