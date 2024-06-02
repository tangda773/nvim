-- Set the Python 3 host program
vim.g.python3_host_prog = "/usr/bin/python3"

-- Require basic settings module
require("basic")

-- Require plugins management module
require("plugins")

if vim.g.neovide then
  vim.o.guifont = "FiraCode Nerd Font Mono:h24"
  -- Helper function for transparency formatting
  -- local alpha = function()
  --   return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
  -- end
  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  vim.g.neovide_transparency = 0.8
  vim.g.transparency = 0.8
  -- vim.g.neovide_background_color = "#0f1117" .. alpha()
end
