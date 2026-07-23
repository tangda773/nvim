return {
  "akinsho/toggleterm.nvim",
  version = vim.version.range("*"),
  keys = {
    { "<leader>Tt", desc = "[Term] Bottom horizontal" },
    { "<leader>Tv", desc = "[Term] Right vertical" },
    { "<leader>Tf", desc = "[Term] Float" },
    { "<leader>Tn", desc = "[Term] New tab" },
  },
  config = function()
    require("toggleterm").setup({
      -- 動態大小，依方向調整 [web:223]
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.25)   -- 底部占 25% 高度
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.33) -- 右側占約 1/3 寬度
        else
          return 20
        end
      end,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "horizontal", -- 預設方向，個別 toggle 覆寫 [web:225]
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "rounded",
        winblend = 0,
      },
    })

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- 小工具：在所有 terminal buffer 裡提供 <Esc><Esc> 回 normal mode
    local function set_term_esc_key()
      vim.api.nvim_create_autocmd("TermOpen", {
        group = vim.api.nvim_create_augroup("ToggleTermEsc", { clear = true }),
        pattern = "term://*",
        callback = function(ev)
          vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], {
            buffer = ev.buf,
            noremap = true,
            silent = true,
            desc = "Terminal: normal mode",
          })
        end,
      })
    end

    set_term_esc_key()

    -- T1: 底部水平分割（長輸出，例如 cargo test --watch）
    map({ "n", "t" }, "<leader>Tt", function()
      require("toggleterm").toggle(1, 0, vim.uv.cwd(), "horizontal")
    end, vim.tbl_extend("force", opts, { desc = "[Term] Bottom horizontal" }))

    -- T2: 右側垂直分割（互動 shell / REPL）
    map({ "n", "t" }, "<leader>Tv", function()
      require("toggleterm").toggle(2, 0, vim.uv.cwd(), "vertical")
    end, vim.tbl_extend("force", opts, { desc = "[Term] Right vertical" }))

    -- T3: float（臨時工具，如 lazygit / htop）
    map({ "n", "t" }, "<leader>Tf", function()
      require("toggleterm").toggle(3, 0, vim.uv.cwd(), "float")
    end, vim.tbl_extend("force", opts, { desc = "[Term] Float" }))

    -- T4: tab 方向（獨立 tab terminal，適合長 session）
    map({ "n", "t" }, "<leader>Tn", function()
      require("toggleterm").toggle(4, 0, vim.uv.cwd(), "tab")
    end, vim.tbl_extend("force", opts, { desc = "[Term] New tab" }))
  end,
}
