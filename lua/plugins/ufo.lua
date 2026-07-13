return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async'
  },
  event = "BufReadPost",
  config = function()
    vim.opt.foldcolumn = '1' -- '0' is not bad
    vim.opt.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    local ft_map = {
      -- 沒有好 LSP 的語言改用 TS
      lua = { "treesitter", "indent" },
      vim = "indent",
    }

    require('ufo').setup({
      fold_virt_text_handler = handler,
      provider_selector = function(bufnr, filetype, buftype)
        return ft_map[filetype] or { "lsp", "indent" }
      end,
      preview = {
        mappings = {
          scrollU = '<C-U>',
          scrollD = '<C-D>',
          scrollE = '<C-E>',
          scrollY = '<C-Y>',
          close = 'q',
          switch = '<Tab>',
          trace = '<CR>'
        }
      }
    })
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "nvim-ufo openAllFolds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "nvim-ufo closeAllFolds" })
    vim.keymap.set("n", "K", function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover() -- 如果沒有折疊就呼叫LSP Hover
      end
    end)
  end
}
