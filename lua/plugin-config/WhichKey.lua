local wk = require("which-key")

local conf = {}

local opts = {
	silent = true,
	noremap = true,
}

-- local mappings = require("keybindings").mappings
local mappings = {}

wk.setup(conf)
wk.register(mappings, opts)
