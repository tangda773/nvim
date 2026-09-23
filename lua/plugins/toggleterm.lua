return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-t>", desc = "[Terminal] Bottom horizontal" },
    { "<C-v>", desc = "[Terminal] Right vertical" },
    { "<C-g>", desc = "[Terminal] Float" },
    { "<C-y>", desc = "[Terminal] New tab" },
  },
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.25)
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.33)
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
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "rounded",
        winblend = 0,
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal

    -- ── 核心優化：改用純 Ctrl 單鍵，不用 leader 多字元序列 ──
    -- 單鍵在 terminal-job mode 下會被立即攔截，不受 timeoutlen 影響，
    -- 不會有「打太慢就送進 shell」的問題，自然也不需要手動按 ESC。

    local function toggle_term(id, direction)
      require("toggleterm").toggle(id, 0, vim.uv.cwd(), direction)
    end

    local opts = { noremap = true, silent = true }

    vim.keymap.set({ "n", "t" }, "<C-t>", function()
      toggle_term(1, "horizontal")
    end, vim.tbl_extend("force", opts, { desc = "[Terminal] Bottom horizontal" }))

    vim.keymap.set({ "n", "t" }, "<C-v>", function()
      toggle_term(2, "vertical")
    end, vim.tbl_extend("force", opts, { desc = "[Terminal] Right vertical" }))

    vim.keymap.set({ "n", "t" }, "<C-g>", function()
      toggle_term(3, "float")
    end, vim.tbl_extend("force", opts, { desc = "[Terminal] Float" }))

    vim.keymap.set({ "n", "t" }, "<C-y>", function()
      toggle_term(4, "tab")
    end, vim.tbl_extend("force", opts, { desc = "[Terminal] New tab" }))

    -- ── 終端機內視窗導航：內建自動離開 terminal mode，你不用手動按 ESC ──
    local function set_terminal_keymaps()
      local map_opts = { buffer = 0, noremap = true, silent = true }
      vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], map_opts)
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], map_opts)
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], map_opts)
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], map_opts)
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], map_opts)
      -- 快速回到上一個編輯用的一般 buffer
      vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>p]], map_opts)
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("ToggleTermKeymaps", { clear = true }),
      pattern = "term://*",
      callback = set_terminal_keymaps,
    })
  end,
}
