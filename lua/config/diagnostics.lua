local M = {}

local function refresh_lists()
  local qf = vim.fn.getqflist({ title = 0, winid = 0 })
  if qf.winid ~= 0 and qf.title == "Diagnostics" then
    vim.diagnostic.setqflist({ open = false })
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ll = vim.fn.getloclist(win, { title = 0, winid = 0 })
    if ll.winid ~= 0 and ll.title == "Diagnostics" then
      vim.diagnostic.setloclist({ open = false, winnr = win })
    end
  end
end

function M.setup()
  vim.diagnostic.config({
    signs = { severity = { min = vim.diagnostic.severity.WARN } },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_lines = {
      current_line = true,
      severity = { min = vim.diagnostic.severity.WARN },
    },
    virtual_text = false,
    severity_sort = true,
    update_in_insert = false,
  })

  -- 全域 keymap（不依賴 LSP attach）
  local function map(keys, func, desc)
    vim.keymap.set("n", keys, func, { desc = desc })
  end
  map("<leader>xe", vim.diagnostic.open_float, "[Diagnostics] Line diagnostics")
  map("<leader>xq", vim.diagnostic.setqflist, "[Diagnostics] Send to quickfix")
  map("<leader>xl", vim.diagnostic.setloclist, "[Diagnostics] Send to loclist")
  map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "[Diagnostics] Next")
  map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "[Diagnostics] Prev")
  map("]e", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
  end, "[Diagnostics] Next error")
  map("[e", function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
  end, "[Diagnostics] Prev error")

  -- 開著的 quickfix/loclist 自動跟著診斷刷新（100ms 合併連續事件）
  local pending = false
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = vim.api.nvim_create_augroup("UserDiagnosticListRefresh", { clear = true }),
    callback = function()
      if pending then
        return
      end
      pending = true
      vim.defer_fn(function()
        pending = false
        refresh_lists()
      end, 100)
    end,
  })
end

return M
