-- ~/.config/nvim/lua/plugins/orgmode.lua
return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  config = function()
    local ok, settings = pcall(require, "config.orgmode-settings")
    if not ok then
      vim.notify("orgmode-settings.lua loading failed: " .. settings, vim.log.levels.ERROR)
      return
    end
    require("orgmode").setup(settings)

    -- lua/config/keymaps-org.lua
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Org 全域核心：Agenda / Capture / Inbox
    map("n", "<leader>oa", function()
      require("orgmode").action("agenda.prompt")
    end, vim.tbl_extend("force", opts, { desc = "Org: Agenda prompt" }))

    map("n", "<leader>oc", function()
      require("orgmode").action("capture.prompt")
    end, vim.tbl_extend("force", opts, { desc = "Org: Capture prompt" }))

    map("n", "<leader>oi", function()
      vim.cmd.edit(vim.fn.expand("~/org/inbox.org"))
    end, vim.tbl_extend("force", opts, { desc = "Org: Open inbox.org" }))

    local api = vim.api

    local org_group = api.nvim_create_augroup("OrgBufferSetup", { clear = true })

    api.nvim_create_autocmd("FileType", {
      group = org_group,
      pattern = "org",
      callback = function(ev)
        -- 視覺 / 顯示
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = false -- 如果不想被拼字檢查打擾
        -- vim.opt_local.spelllang = "en_us"

        vim.opt_local.breakindent = true
        vim.opt_local.formatoptions:remove("c")
        vim.opt_local.formatoptions:remove("r")
        vim.opt_local.formatoptions:remove("o")

        -- Org buffer 專用 LocalLeader keymap
        local function bmap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            noremap = true,
            silent = true,
            buffer = ev.buf,
            desc = desc,
          })
        end

        -- TODO 狀態操作
        bmap("n", "<localleader>ot", function()
          require("orgmode").action("todo.set_todo")
        end, "Org: Cycle TODO")

        bmap("n", "<localleader>oT", function()
          require("orgmode").action("todo.set_todo", { pop = true })
        end, "Org: Choose TODO")

        -- 日期 / 時間
        bmap("n", "<localleader>od", function()
          require("orgmode").action("clock.org_deadline")
        end, "Org: Set DEADLINE")

        bmap("n", "<localleader>os", function()
          require("orgmode").action("clock.org_schedule")
        end, "Org: Set SCHEDULED")

        bmap("n", "<localleader>oi", function()
          require("orgmode").action("org.insert_timestamp")
        end, "Org: Insert timestamp")

        -- Link / tags
        bmap("n", "<localleader>ol", function()
          require("orgmode").action("org.insert_link")
        end, "Org: Insert link")

        bmap("n", "<localleader>oq", function()
          require("orgmode").action("org.set_tags")
        end, "Org: Set tags")

        -- Narrow / Widen
        bmap("n", "<localleader>on", function()
          require("orgmode").action("org.narrow")
        end, "Org: Narrow subtree")

        bmap("n", "<localleader>oN", function()
          require("orgmode").action("org.widen")
        end, "Org: Widen")

        -- -- src block 操作
        -- bmap("n", "<localleader>oE", function()
        --   require("orgmode").action("org.edit_special")
        -- end, "Org: Edit src block")

        -- bmap("n", "<localleader>oB", function()
        --   require("orgmode").action("babel.execute_block")
        -- end, "Org: Execute src block")
      end,
    })
  end,
}
