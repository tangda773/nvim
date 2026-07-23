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

    -- ── 其他全部關掉 ──────────────────────────
    bigfile      = { enabled = false }, -- faster.nvim
    animate      = { enabled = false }, -- mini.animate
    dashboard    = { enabled = false }, -- mini.starter
    explorer     = { enabled = false }, -- mini.files
    indent       = { enabled = false }, -- mini.indentscope
    picker       = { enabled = false }, -- fzf-lua
    quickfile    = { enabled = false }, -- faster.nvim
    scope        = { enabled = false }, -- mini.indentscope
    scroll       = { enabled = false }, -- mini.animate
    statuscolumn = { enabled = false }, -- statuscol.nvim
    terminal     = { enabled = false }, -- toggleterm
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
    { "<leader>fs", function() Snacks.scratch.select() end,           desc = "Select scratch" },

    -- notifier 歷史
    { "<leader>fn", function() Snacks.notifier.show_history() end,    desc = "Notify history" },

    -- profiler
    { "<leader>pp", function() Snacks.toggle.profiler():toggle() end, desc = "Toggle profiler", },
    { "<leader>ps", function() Snacks.profiler.scratch() end,         desc = "Profiler scratch", },
  }
}
