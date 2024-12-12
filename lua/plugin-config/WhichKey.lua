local wk = require("which-key")

local conf = {}

local opts = {
  silent = true,
  noremap = true,
}

-- local mappings = require("keybindings").mappings

wk.setup(conf)
-- wk.register(mappings, opts)
wk.add({
  mode = { "v" },
  { "<leader>s", group = "Silicon" },
  {
    "<leader>sc",
    function()
      require("nvim-silicon").clip()
    end,
    desc = "Copy code screenshot to clipboard",
  },
  {
    "<leader>sf",
    function()
      require("nvim-silicon").file()
    end,
    desc = "Save code screenshot as file",
  },
  {
    "<leader>ss",
    function()
      require("nvim-silicon").shoot()
    end,
    desc = "Create code screenshot",
  },
})

wk.add({
  mode = { "n" },
  {
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    desc = "Find Next Char",
  },
  {
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    desc = "Find Previous Char",
  },
  {
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset=-1 })<cr>",
    desc = "Find Next Char(Before Char)",
  },
  {
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset=-1 })<cr>",
    desc = "Find Previous Char(Before Char)",
  },
})

wk.add({
  mode = { "n" },
  { "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "DAP Toggle Breakpoint" },
  { "<F5>", "<cmd>lua require'dap'.continue()<CR>", desc = "DAP Continue" },
  { "<F11>", "<cmd>lua require'dap'.step_into()<CR>", desc = "DAP Step Into" },
  { "<F12>", "<cmd>lua require'dap'.step_over()<CR>", desc = "DAP Step Over" },
})

wk.add({
  mode = { "n" },
  { "<A-n>", "<cmd>lua require'illuminate'.next_reference{wrap=true}<cr>", desc = "Next Reference" },
  {
    "<A-p>",
    "<cmd>lua require'illuminate'.next_reference{reverse=true,wrap=true}<cr>",
    desc = "Next Reference Reverse",
  },
})

wk.add({
  mode = { "n" },
  {
    "<C-p>",
    ":Telescope find_files<cr>",
    desc = "Telescope Find Files",
  },
  {
    "<C-g>",
    "<cmd>:lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
    desc = "Telescope Live Grep args",
  },
  {
    "<leader>@",
    ":Telescope lsp_dynamic_workspace_symbols theme=dropdown<CR>",
    desc = "Telescope Find Workspace LSP Symbols",
  },
})

wk.add({
  mode = { "n" },
  { "g", group = "+LSP functions" },
  { "go", desc = "Show Line Diagnostics" },
  { "gs", desc = "Show Symbol Outline" },
  { "gD", desc = "Show Declaration" },
  { "gd", desc = "Peek Definitions" },
  { "gh", desc = "Show Hover Doc" },
  { "gi", desc = "Show Implementation" },
  { "gf", desc = "Show Finder" },
  { "gn", desc = "Diagnostics Jump Next" },
  { "gp", desc = "Diagnostics Jump Prev" },
  { "gx", desc = "URL Open Under Cursor" },
  { "<leader>=", desc = "Lsp Formatting" },
  { "<leader>xa", desc = "Lsp Code Action" },
})

wk.add({
  mode = { "n" },
  { "<leader>x", group = "+Trouble" },
  { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
  { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
  { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
  {
    "<leader>cl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    desc = "Lsp Definitions / references / ... (Trouble)",
  },
  { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
  { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
})

wk.add({
  mode = { "n" },
  { "<leader>h", group = "+Gitsigns" },
  { "<leader>hs", desc = "Gitsigns Stage Hunk" },
  { "<leader>hr", desc = "Gitsigns Reset Hunk" },
  { "<leader>hS", desc = "Gitsigns Stage Buffer" },
  { "<leader>hu", desc = "Gitsigns Undo Stage Buffer" },
  { "<leader>hR", desc = "Gitsigns Reset Buffer" },
  { "<leader>hp", desc = "Gitsigns Preview Hunk" },
  { "<leader>hb", desc = "Gitsigns Blame Line" },
  { "<leader>hd", desc = "Gitsigns Diff This" },
  { "<leader>hD", desc = "Gitsigns Diff This(~)" },
  { "<leader>tb", desc = "Gitsigns Toggle Current Line Blame" },
  { "<leader>td", desc = "Gitsigns Toggle Deleted" },
})

wk.add({
  mode = { "n" },
  { "<leader>t", group = "+Overseer && Neotest" },
  { "<leader>tr", ":OverseerRun<CR>", desc = "Overseer Run Tasks" },
  { "<leader>to", ":OverseerQuickAction open float<CR>", desc = "Overseer Show Tasks Output" },
  { "<leader>tt", ":lua require('neotest').run.run()<CR>", desc = "Neotest Run Current Line" },
})

wk.add({
  mode = { "n" },
  { "<leader>e", ":Neotree<CR>", desc = "NeoTree" },
})

wk.add({
  mode = { "n" },
  { "<leader>bd", ":Bdelete<CR>", desc = "BufDelete" },
})

wk.add({
  mode = { "n" },
  { "]t", "<cmd> lua require('todo-comments').jump_next()<CR>", desc = "TODO Jump Next" },
  { "[t", "<cmd> lua require('todo-comments').jump_prev()<CR>", desc = "TODO Jump Prev" },
})

wk.add({
  mode = { "n" },
  { "<leader>v", group = "+VenvSelect" },
  { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "VenvSelect" },
  { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "VenvSelectCached" },
})

wk.add({
  mode = { "n" },
  { "<leader>f", "<cmd>Format<cr>", desc = "Format files" },
})

wk.add({
  mode = {"n"},
  {"zR", "<cmd>lua require('ufo').openAllFolds()<CR>",desc="open All Folds"},
  {"zM", "<cmd>lua require('ufo').closeAllFolds()<CR>",desc="close All Folds"},
})
