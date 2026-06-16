return{
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed.
    -- "nvim-telescope/telescope.nvim", -- optional
    {"ibhagwan/fzf-lua",optional =true},              -- optional
    -- "echasnovski/mini.pick",         -- optional
    -- "folke/snacks.nvim",             -- optional
  },
}
