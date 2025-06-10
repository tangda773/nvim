local pluginKeys = {}

local opt = {
  noremap = true, silent = true,
}

-- Telescope 列表中 插入模式快捷鍵
pluginKeys.telescopeList = {
  i = {
    ["<C-n>"] = require("telescope.actions").cycle_history_next,
    ["<C-p>"] = require("telescope.actions").cycle_history_prev,
    ["<C-j>"] = require("telescope.actions").move_selection_next,
    ["<C-k>"] = require("telescope.actions").move_selection_previous,
  },
}

-- lsp 回調函數快捷鍵設置
pluginKeys.mapLSP = function(mapbuf)
  -- rename
  mapbuf("n", "<leader>rn", ":Lspsaga rename<CR>", opt)
  -- mapbuf("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opt)
  -- code action
  mapbuf("n", "<leader>xa", ":Lspsaga code_action<CR>", opt)
  -- mapbuf("n", "<leader>xa", "<cmd>lua vim.lsp.buf.code_action()<CR>", opt)
  -- go xx
  mapbuf("n", "gf", ":Lspsaga finder<CR>", opt)
  mapbuf("n", "gd", ":Lspsaga peek_definition<CR>", opt)
  -- mapbuf("n", "gd", "<cmd>lua vim.lsp.buf.definition<CR>", opt)
  mapbuf("n", "gh", ":Lspsaga hover_doc<CR>", opt)
  -- mapbuf("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
  mapbuf("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
  mapbuf("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opt)
  mapbuf("n", "go", ":Lspsaga show_line_diagnostics<CR>", opt)
  mapbuf("n", "gs", ":Lspsaga outline<CR>", opt)
  mapbuf("n", "gn", ":Lspsaga diagnostic_jump_next<cr>", opt)
  mapbuf("n", "gp", ":Lspsaga diagnostic_jump_prev<cr>", opt)
  -- formatter
  mapbuf("n", "<leader>=", "<cmd>lua vim.lsp.buf.format{async = true}<CR>", opt)
end

-- nvim-cmp 自動補全
local luasnip = require("luasnip")
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local neogen = require("neogen")
pluginKeys.cmp = function(cmp)
  return {
    -- 確認
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    }),
    -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif neogen.jumpable() then
        neogen.jump_next()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif neogen.jumpable(true) then
        neogen.jump_prev()
      else
        fallback()
      end
    end, { "i", "s" }),
  }
end

return pluginKeys
