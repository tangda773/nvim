local powershell_options = {
  shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
  shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
  shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
  shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
  shellquote = "",
  shellxquote = "",
}

for option, value in pairs(powershell_options) do
  vim.opt[option] = value
end

local check_and_pick_venv = function()
  local function get_virtualenv_path(path)
    if path == nil then
      return nil
    end
    -- Normalize backslashes to forward slashes for cross-platform compatibility
    local normalized_path = string.gsub(path, "\\", "/")
    -- Find "envs" in the path
    local start_pos, end_pos = string.find(normalized_path, "envs")
    if start_pos then
      -- Extract the virtualenv path
      local virtualenv_path = string.match(normalized_path, "^(.*%/envs/[^/]+)")
      return virtualenv_path
    else
      return nil
    end
  end
  local python_exectuable = require("venv-selector").python()
  local venv = get_virtualenv_path(python_exectuable)
  if venv ~= nil then
    return venv
  else
    return nil
  end
end

require("toggleterm").setup({
  open_mapping = [[<c-\>]],
  cmd = check_and_pick_venv(),
  hide_number = true,
  direction = "float",
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  on_create = function()
    local venv = check_and_pick_venv()
    if venv ~= nil then
      vim.cmd('TermExec cmd="conda activate ' .. venv .. '"')
    end
  end,
})

local Terminal = require("toggleterm.terminal").Terminal
local ipython = Terminal:new({
  on_create = function()
    local venv = check_and_pick_venv()
    if venv ~= nil then
      vim.cmd('TermExec cmd="conda activate ' .. venv .. ' && ipython --no-autoindent"')
    else
      vim.cmd('TermExec cmd="ipython --no-autoindent"')
    end
  end,
})

function _ipython_toggle()
  ipython:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _ipython_toggle()<CR>", { noremap = true, silent = true })
